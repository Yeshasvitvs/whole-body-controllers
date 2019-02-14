function euler = rotm2euler(rotm)

  x = atan2(rotm(3,2),rotm(3,3)); %%Radians 
  y = atan2(-rotm(3,1),sqrt(rotm(3,2)^2 + rotm(3,3)^2));
  z = atan2(rotm(2,1),rotm(1,1));
  
  euler = [x; y; z]; %%This is expressed in ZYX order
  
end