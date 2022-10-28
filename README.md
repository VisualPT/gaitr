# Gaiter - gait velocity detection

Healthcare tool for accelerating therapist measurements.
Gait Velocity is most accurately measured over 10 meters with 2 extra meters on both ends for acceleration and deceleration.

Fall Risk is calculated using the patients measured gait velocity over 10 meters.
It is a direct linear function with time and risk as the two variables. Anything under 7 seconds indicates 0% risk and anything over 27 seconds indicates 100% fall risk. 
Presenting the fall risk probability facilitates an understanding of the patient, as a percentage is more meaningful than a vector to the patient.

## Data Stored in HIPAA-Compliant AWS Cloud Storage
* Patient-facing Physical Therapist email
* Manually input patient information (Name, Birthdate)
* Patient Gait Velocity Value and generated PDF for EMR documenting and insurance billing purposes



Sources 
1. [https://www.researchgate.net/publication/284885443_Walking_speed_The_sixth_vital_sign]
