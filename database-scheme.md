# Database scheme


## Collections

- /users/{userId}
    - /transactions/{transactionId} -> **create** by cloud function only, **read** only by user

- /donations/{donationId} -> after **create**, the donor has **read**-only permission, 
    - /questions/{questionId} -> only creator, assigned collector and center-admins can **read** and **write**
    - /verificationSteps/{verificationStepId} -> only creator, assigned collector and center-admins can **read** and **create**, **update** or **delete** is denied due to security reasons

- /services/{serviceId} -> auto **create** by cloud function if *donation needs collection*

- /questions/{questionId} -> general discussion on the platform, sorted by geo-location
    - /answers/{answerId}
- /centers/{centerId} 
    - /admins/{adminId}

- /