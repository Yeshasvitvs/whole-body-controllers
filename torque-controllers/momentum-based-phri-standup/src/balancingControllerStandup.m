%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /**
%  * Copyright (C) 2016 CoDyCo
%  * @author: Daniele Pucci
%  * Permission is granted to copy, distribute, and/or modify this program
%  * under the terms of the GNU General Public License, version 2 or any
%  * later version published by the Free Software Foundation.
%  *
%  * A copy of the license can be found at
%  * http://www.robotcub.org/icub/license/gpl.txt
%  *
%  * This program is distributed in the hope that it will be useful, but
%  * WITHOUT ANY WARRANTY; without even the implied warranty of
%  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
%  * Public License for more details
%  */
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [tauModel, Sigma, NA, f_LDot, ...
          HessianMatrixQP1Foot, gradientQP1Foot, ConstraintsMatrixQP1Foot, bVectorConstraintsQp1Foot, ...
          HessianMatrixQP2FeetOrLegs, gradientQP2FeetOrLegs, ConstraintsMatrixQP2FeetOrLegs, bVectorConstraintsQp2FeetOrLegs, ...
          errorCoM, f_noQP, correctionFromSupportForce, L_error, V, alpha, fArms, phri_assistant_feet_wrench, phri_robot_feet_wrench, correctionFromSupportTorque] =  ...
              balancingControllerStandup(constraints, ROBOT_DOF_FOR_SIMULINK, ASSISTANT_DOF_FOR_SIMULINK, ConstraintsMatrix, bVectorConstraints, ...
                                         qj, qjDes, nu, M, h, L, intLw, w_H_l_contact, w_H_r_contact, JL, JR, dJL_nu, dJR_nu, xCoM, J_CoM, desired_x_dx_ddx_CoM, Jcmm, ...
                                         gainsPCOM, gainsDCOM, impedances, Reg, Gain, w_H_lArm, w_H_rArm, JLArm, JRArm, dJLArm_nu, dJRArm_nu,...
                                         LArmWrench, RArmWrench, STANDUP_WITH_ASSISTANT_FORCE, MEASURED_FT, STANDUP_WITH_ASSISTANT_TORQUE, ...
                                         assistant_w_H_b, assistant_qj, assistant_nu_b, assistant_dqj, assistant_M, assistant_h, assistant_torques, ...
                                         assistant_w_H_l_contact, assistant_w_H_r_contact, assistant_JL, assistant_JR, assistant_dJL_nu, assistant_dJR_nu,...
                                         assistant_w_H_lArm_contact, assistant_w_H_rArm_contact, assistant_JLArm, assistant_JRArm, assistant_dJLArm_nu, assistant_dJRArm_nu,...
                                         state, robot_torques, SOLO_ROBOT)
       
    % BALANCING CONTROLLER

    %% DEFINITION OF CONTROL AND DYNAMIC VARIABLES
    pos_leftContact    = w_H_l_contact(1:3,4);
    w_R_l_contact      = w_H_l_contact(1:3,1:3);
    pos_rightContact   = w_H_r_contact(1:3,4);
    w_R_r_contact      = w_H_r_contact(1:3,1:3);
    
    % arms position
    pos_leftArm     = w_H_lArm(1:3,4);
    pos_rightArm    = w_H_rArm(1:3,4);
    
    dampings       = Gain.dampings;
    ROBOT_DOF      = size(ROBOT_DOF_FOR_SIMULINK,1);
    ASSISTANT_DOF  = size(ASSISTANT_DOF_FOR_SIMULINK,1);
    gravAcc        = 9.81;
   
    % Mass of the robot
    m              = M(1,1);
    
    % The mass matrix is partitioned as:
    %
    %   M = [ Mb,   Mbj
    %         Mbj', Mj ];  
    %
    % where: Mb  \in R^{6x6}
    %        Mbj \in R^{6x6+nDof}
    %        Mj  \in R^{nDofxnDof}
    %
    Mb             = M(1:6,1:6);
    Mbj            = M(1:6,7:end);
    Mj             = M(7:end,7:end);

    St             = [zeros(6,ROBOT_DOF);
                      eye(ROBOT_DOF,ROBOT_DOF)];
                  
    assistant_St   = [zeros(6,ASSISTANT_DOF);
                      eye(ASSISTANT_DOF,ASSISTANT_DOF)];
                  
    combined_torques = [assistant_torques; robot_torques];
                  
    gravityWrench  = [zeros(2,1);
                     -m*gravAcc;
                      zeros(3,1)];

    % Velocity of the center of mass
    xCoM_dot       = J_CoM(1:3,:)*nu;
    
    % Joint velocity
    qjDot          = nu(7:end);
    
    % Joint position error
    qjTilde        =  qj-qjDes;
    
    % Desired acceleration for the center of mass
    xDDcomStar     = desired_x_dx_ddx_CoM(:,3) -gainsPCOM.*(xCoM - desired_x_dx_ddx_CoM(:,1)) -gainsDCOM.*(xCoM_dot - desired_x_dx_ddx_CoM(:,2));
                    
    % Application point of the contact force on the right contact link w.r.t. CoM
    Pr              = pos_rightContact -xCoM; 
    
    % Application point of the contact force on the left contact link w.r.t. CoM
    Pl              = pos_leftContact  -xCoM; 
    
    % Arms location w.r.t. CoM
    PlArm           = pos_leftArm   -xCoM; 
    PrArm           = pos_rightArm  -xCoM;

    % The following variables serve for determening the rate-of-change of
    % the robot's momentum. In particular, when balancing on two feet, one has:
    %
    %   dot(H) = gravityWrench +  AL*f_L + AR*f_R
    %          = gravityWrench + [AL,AR]*f
    %
    % where  f_L and f_R are the contact wrenches acting on the left and
    % right foot, respectively, and f = [f_L;f_R].
    %
    AL              = [ eye(3),zeros(3);
                        skew(Pl), eye(3)];
    AR              = [ eye(3), zeros(3);
                        skew(Pr), eye(3)];

    % dot(H) = mg + A*f
    A               = [AL, AR]; 
    
    % matrix multipliyng the forces at arms
    A_lArm          = [ eye(3),     zeros(3);
                        skew(PlArm),  eye(3)];    
    A_rArm          = [ eye(3),     zeros(3);
                        skew(PrArm),  eye(3)];  
                    
    A_arms          = [A_lArm, A_rArm]; 
    
    pinvA           = pinv(A, Reg.pinvTol)*constraints(1)*constraints(2)  ...
                      + [inv(AL);zeros(6)]*constraints(1)*(1-constraints(2)) ... 
                      + [zeros(6);inv(AR)]*constraints(2)*(1-constraints(1)); 

    % Null space of the matrix A            
    NA              = (eye(12,12)-pinvA*A)*constraints(1)*constraints(2);

    % Total wrench applied at arms. External force is decomposed into two components
    % along the direction of momentum error. Then, the parallel component is considered
    fArms           = [LArmWrench;
                       RArmWrench];
                   
    % support force               
    fsupport        = A_arms * fArms;
    
    % Time varying contact jacobian
    Jc              = [JL*constraints(1);      
                       JR*constraints(2)];
                   
    % Time varying contact jacobian
    JcArm           = [JLArm;      
                       JRArm];
                   
    % Time varying dot(J)*nu
    Jc_nuDot        = [dJL_nu*constraints(1) ;      
                       dJR_nu*constraints(2)];

    JcMinv          = Jc/M;
    JcMinvSt        = JcMinv*St;
    JcMinvJct       = JcMinv*transpose(Jc);
    
    % multiplier of f in tau
    JBar            = transpose(Jc(:,7:end)) -Mbj'/Mb*transpose(Jc(:,1:6)); 

    Pinv_JcMinvSt   = pinvDamped(JcMinvSt,Reg.pinvDamp); 
   
    % nullJcMinvSt --> null space of Pinv_JcMinvSt
    nullJcMinvSt    = eye(ROBOT_DOF) - Pinv_JcMinvSt*JcMinvSt;

    % Mbar is the mass matrix associated with the joint dynamics, i.e.
    Mbar            = Mj-Mbj'/Mb*Mbj;
    NLMbar          = nullJcMinvSt*Mbar;
    
    % Adaptation of control gains for back compatibility with older
    % versions of the controller
    impedances      = diag(impedances)*pinv(NLMbar,Reg.pinvTol) + Reg.impedances*eye(ROBOT_DOF);
    dampings        = diag(dampings)*pinv(NLMbar,Reg.pinvTol)   + Reg.dampings*eye(ROBOT_DOF);       
                                    
    % desired robot momentum
    L_desired  = [m.*desired_x_dx_ddx_CoM(:,2);
                  zeros(3,1)];
              
    % momentum error
    L_error    = L -L_desired;
    
    % projector of contact forces into the direction parallel to momentum
    % error
    alpha = 100; %%This is the default value
    correctionFromSupportForce = zeros(6,1);
    L_errParallel = L_error/(norm(L_error)+Reg.norm_tolerance);
    
    %% The total contacts of the combined system are 6
    %% Hence the rows are 6 x 6 = 36
    phri_assistant_feet_wrench = zeros(12,1);
    phri_robot_feet_wrench = zeros(12,1);
    Big_G1 = zeros(36,ASSISTANT_DOF);
    Big_G2 = zeros(36,ROBOT_DOF);
    Big_G3 = zeros(36,1);
    
    if (STANDUP_WITH_ASSISTANT_FORCE && MEASURED_FT) %% This is the case of using measured FT from WBD for standup
        
        alpha         = (transpose(L_error)*fsupport)/(norm(L_error)+Reg.norm_tolerance);
    
    elseif (~SOLO_ROBOT && ((STANDUP_WITH_ASSISTANT_FORCE && ~MEASURED_FT) || STANDUP_WITH_ASSISTANT_TORQUE)) %%This is used in case of using computed FT or assistant joint torques
        
        Big_M          = [assistant_M,                           zeros(6+ASSISTANT_DOF,6+ROBOT_DOF);
                          zeros(6+ROBOT_DOF,6+ASSISTANT_DOF),    M];
                  
        Big_Minv       = (eye(size(Big_M,1)))/(Big_M + 0.000001*eye(size(Big_M,1)));
        
        Big_h          = [assistant_h; h];
                      
        %% The interaction wrench on human is considered here
        % TODO: This contact jacobian transpose assumes that the hand frames are coinciding
        % This assumption is not true in the case of using two icub models
        % as there is a rotation of 180 degress around y-axis. So to get
        % the correct interaction wrench values in all the directions, this
        % transformation has to be accounted.
        Big_Jct        = [assistant_JL'             assistant_JR'               zeros(6+ASSISTANT_DOF,6)             zeros(6+ASSISTANT_DOF,6)           assistant_JLArm'            assistant_JRArm';
                          zeros(6+ROBOT_DOF,6)      zeros(6+ROBOT_DOF,6)        (JL*constraints(1))'                 (JR*constraints(2))'               -JLArm'                     -JRArm'];
    
        Big_Q          = [assistant_JL              zeros(6,6+ROBOT_DOF);
                          assistant_JR              zeros(6,6+ROBOT_DOF);
                          zeros(6,6+ASSISTANT_DOF)  JL*constraints(1);
                          zeros(6,6+ASSISTANT_DOF)  JR*constraints(2);
                          assistant_JLArm           -JLArm;
                          assistant_JRArm           -JRArm];
    
        Big_PV          = [assistant_dJL_nu;
                           assistant_dJR_nu;
                           dJL_nu*constraints(1);
                           dJR_nu*constraints(2);
                           assistant_dJLArm_nu - dJLArm_nu;
                           assistant_dJRArm_nu - dJRArm_nu];
    
        Big_Gamma      = Big_Q*Big_Minv*Big_Jct;
        
        regularization_term = 1;
        if(STANDUP_WITH_ASSISTANT_FORCE && ~MEASURED_FT)
            regularization_term = 0.000001;
        end
        Big_Gammainv   = (eye(size(Big_Gamma,1)))/(Big_Gamma + regularization_term*eye(size(Big_Gamma,1)));
        
        Big_GammainvQMinv = Big_Gammainv*Big_Q*Big_Minv;
        
        Big_G1        = - Big_GammainvQMinv*[assistant_St; zeros(6+ROBOT_DOF,ASSISTANT_DOF)] ;
        Big_G2        = - Big_GammainvQMinv*[zeros(6+ASSISTANT_DOF,ROBOT_DOF); St];
        Big_G3        =   Big_Gammainv*(Big_Q*Big_Minv*Big_h - Big_PV);
        
        if(STANDUP_WITH_ASSISTANT_FORCE && ~MEASURED_FT)
            
            combined_wrench    = [Big_G1 Big_G2]*combined_torques + Big_G3;
        
            phri_assistant_feet_wrench   = [combined_wrench(1:6,:);
                                            combined_wrench(7:12,:)];
        
            phri_robot_feet_wrench       = [combined_wrench(13:18,:);
                                            combined_wrench(19:24,:)];
        
            %% The interaction wrench acting on the robot is equal and opposite to that of the computed wrench, hence -ve sign
            phri_fArms      =   -[combined_wrench(25:30,:);
                                  combined_wrench(31:end,:)];
                     
            fArms           = phri_fArms;
            
            phri_fsupport   = A_arms * phri_fArms;
            
            phri_alpha    = (transpose(L_error)*phri_fsupport)/(norm(L_error)+Reg.norm_tolerance);
            alpha         = phri_alpha;
            
        end
    
    end
    
    if alpha <= 0 && state < 4 && STANDUP_WITH_ASSISTANT_FORCE
        
        correctionFromSupportForce = alpha*L_errParallel;
        
    end               
                
    %% QP PARAMETERS FOR TWO FEET STANDING
    % In the case the robot stands on two feet/legs, the control objective is 
    % the minimization of the joint torques through the redundancy of the 
    % contact forces. By direct calculations one shows that the joint
    % torques take the following form:
    %
    % 0) tau = tauModel + Sigma*f_LDot + SigmaNA*f0
    %
    % where f0 is the redundancy of the contact wrenches. Then, the problem
    % is defined as follows:
    %
    % 1) f0  = argmin |tau(f0)|^2
    %          s.t.
    %          ConstraintsMatrixQP2Contacts*f0 < bVectorConstraintsQp2Contacts
    %
    % Update constraint matrices. The constraint matrix for the inequality
    % constraints in the problem 1) is built up starting from the constraint
    % matrix associated with each single contact. More precisely, the contact
    % wrench associated with the left contact (resp. right contact) is subject to
    % the following constraint:
    %
    % constraintMatrixLeftContact*l_sole_f_L < bVectorConstraints
    %
    % In this case, however, f_L is expressed w.r.t. the frame l_contact,
    % which is solidal to the left contact. Since the controller uses contact
    % wrenches expressed w.r.t. a frame whose orientation is that of the
    % inertial frame, we have to update the constraint matrix according to
    % the transformation w_R_l_contact, i.e.
    %
    % constraintMatrixLeftContact = ConstraintsMatrix*w_R_l_contact
    %
    % The same hold for the right foot
    constraintMatrixLeftContact   = ConstraintsMatrix * blkdiag(w_R_l_contact',w_R_l_contact');
    constraintMatrixRightContact  = ConstraintsMatrix * blkdiag(w_R_r_contact',w_R_r_contact');
    ConstraintsMatrix2FeetOrLegs  = blkdiag(constraintMatrixLeftContact,constraintMatrixRightContact);
    bVectorConstraints2FeetOrLegs = [bVectorConstraints;bVectorConstraints];
    
    tauModel= zeros(ROBOT_DOF,1);
    Sigma   = zeros(ROBOT_DOF,12);
    LDotDes = zeros(6,1);
    int_L_tilde_times_gain = zeros(6,1);
    correctionFromSupportTorque = zeros(6,1);
    if ~STANDUP_WITH_ASSISTANT_TORQUE %% Without considering assistant joint torques
        
        % Terms used in Eq. 0)
        tauModel  = Pinv_JcMinvSt*(JcMinv*h - Jc_nuDot) + nullJcMinvSt*(h(7:end) - Mbj'/Mb*h(1:6) ...
                                  -impedances*NLMbar*qjTilde -dampings*NLMbar*qjDot);
        
        Sigma     = -(Pinv_JcMinvSt*JcMinvJct + nullJcMinvSt*JBar);
        
        % Desired rate-of-change of the robot momentum
        LDotDes   = [m*xDDcomStar ;
                     -Gain.KD_AngularMomentum*L(4:end)-Gain.KP_AngularMomentum*intLw] +correctionFromSupportForce;
         
        int_L_tilde_times_gain = [m * gainsPCOM .* (xCoM - desired_x_dx_ddx_CoM(:,1));
                                  Gain.KP_AngularMomentum .* intLw];
        
    elseif STANDUP_WITH_ASSISTANT_TORQUE %% with assistant joint torques
        
        JcmmMinv = Jcmm/M;
        JcmmMinvJcArmt = JcmmMinv*transpose(JcArm);
        Delta = JcmmMinv*St + JcmmMinvJcArmt*-Big_G2(1:12,:);
        Pinv_Delta = pinvDamped(Delta,1);
        
        nullDelta    = eye(ROBOT_DOF) - Pinv_Delta*Delta;
        
        % Desired rate-of-change of the robot momentum
        LDotDes   = [m*xDDcomStar ;
                     -Gain.KD_AngularMomentum*L(4:end)-Gain.KP_AngularMomentum*intLw];
        
        int_L_tilde_times_gain = [m * gainsPCOM .* (xCoM - desired_x_dx_ddx_CoM(:,1));
                                  Gain.KP_AngularMomentum .* intLw];

        Lambda = JcmmMinvJcArmt*-Big_G3(1:12,:) + gravityWrench + int_L_tilde_times_gain - LDotDes;
        
        Omega = JcmmMinvJcArmt*-Big_G1(1:12,:);
        phri_torque_alpha    = (transpose(L_error)*Omega*assistant_torques)/(norm(L_error)+Reg.norm_tolerance);
        alpha = phri_torque_alpha;
        if phri_torque_alpha >= 0 && state < 4
            correctionFromSupportTorque = phri_torque_alpha*L_errParallel;
        end
        
        local_gain = [ 1    0    0    0    0     0;
                       0    1    0    0    0     0;
                       0    0    1    0    0     0;
                       0    0    0    1    0     0;
                       0    0    0    0    1     0;
                       0    0    0    0    0     1];
                   
        tauModel  = -Pinv_Delta*(Lambda + local_gain*L_error + correctionFromSupportTorque) + nullDelta*(h(7:end) - Mbj'/Mb*h(1:6) ...
                                 -(impedances.*2.5)*NLMbar*qjTilde -(dampings.*1.5)*NLMbar*qjDot);
        
        Sigma = -(Pinv_Delta*JcmmMinv*transpose(Jc) + nullDelta*JBar);
        
    end
    
    % computing Lyapunov function
    V = 0.5 * transpose(L_error) * L_error;
    V = V + 0.5 * transpose(int_L_tilde_times_gain) * int_L_tilde_times_gain;
    
    % Contact wrenches realizing the desired rate-of-change of the robot
    % momentum LDotDes when standing on two feet. Note that f_LDot is
    % different from zero only when both foot are in contact, i.e. 
    % constraints(1) = constraints(2) = 1. This because when the robot
    % stands on one foot, the f_LDot is evaluated directly from the
    % optimizer (see next section).
    f_LDot    = pinvA*(LDotDes - gravityWrench)*constraints(1)*constraints(2);
    SigmaNA   = Sigma*NA;
   
    % The optimization problem 1) seeks for the redundancy of the external
    % wrench that minimize joint torques. Recall that the contact wrench can 
    % be written as:
    %
    % f = f_LDot + NA*f_0 
    %
    % Then, the constraints on the contact wrench is of the form
    %
    % ConstraintsMatrix2Feet*f < bVectorConstraints,
    %
    % which in terms of f0 is:
    %
    % ConstraintsMatrix2Feet*NA*f0 < bVectorConstraints - ConstraintsMatrix2Feet*f_LDot
    ConstraintsMatrixQP2FeetOrLegs  = ConstraintsMatrix2FeetOrLegs*NA;
    bVectorConstraintsQp2FeetOrLegs = bVectorConstraints2FeetOrLegs-ConstraintsMatrix2FeetOrLegs*f_LDot;
    
    % Evaluation of Hessian matrix and gradient vector for solving the
    % optimization problem 1).
    HessianMatrixQP2FeetOrLegs      = SigmaNA'*SigmaNA + eye(size(SigmaNA,2))*Reg.HessianQP;
    gradientQP2FeetOrLegs           = SigmaNA'*(tauModel + Sigma*f_LDot);

    %% QP PARAMETERS FOR ONE FOOT STANDING
    % In the case the robot stands on one foot, there is no redundancy of
    % the contact wrenches. Hence, we cannot use this redundancy for
    % minimizing the joint torques. For this reason, the minimization
    % problem is modified as follows:
    %
    % 2) f = argmin|dot(H)(f) - dot(H)_des|^2
    %        s.t.
    %        ConstraintsMatrixQP1Foot*f < bVectorConstraintsQp1Foot
    %
    % where f is the contact wrench either of the left or on the right
    % foot.
    %
    ConstraintsMatrixQP1Foot  = constraints(1) * (1 - constraints(2)) * ConstraintsMatrix + ...
                                constraints(2) * (1 - constraints(1)) * ConstraintsMatrix;
    bVectorConstraintsQp1Foot = bVectorConstraints;

    A1Foot                    =  AL*constraints(1)*(1-constraints(2)) + AR*constraints(2)*(1-constraints(1));
    HessianMatrixQP1Foot      =  A1Foot'*A1Foot + eye(size(A1Foot,2))*Reg.HessianQP;
    gradientQP1Foot           = -A1Foot'*(LDotDes - gravityWrench);

    %% DEBUG DIAGNOSTICS
    
    % Unconstrained solution for the problem 1)
    f0                        = -pinvDamped(SigmaNA, Reg.pinvDamp*1e-5)*(tauModel + Sigma*f_LDot);
    
    % Unconstrained contact wrenches
    f_noQP                    =  pinvA*(LDotDes - gravityWrench) + NA*f0*constraints(1)*constraints(2); 
    
    % Error on the center of mass
    errorCoM                  =  xCoM - desired_x_dx_ddx_CoM(:,1);
end
