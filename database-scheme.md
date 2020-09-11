# Database scheme


## Collections

- `/users/{userId}`
    - `/transactions/{transactionId}` -> **create** by cloud function only, **read** only by user

- `/donations/{donationId}` -> after **create**, the donor has **read**-only permission, 
    - `/answers/{answerId}` -> only creator, assigned collector and center-admins can **read** and **write**

- `/services/{serviceId}` -> auto **create** by cloud function if *donation needs delivery (COLLECTOR)*
    - `/answers/{answerId}` -> only creator and assigned service prodiver and associated Minga-admins can **read** and **write**

- `/questions/{questionId}` -> general discussion on the platform, sorted by geo-location
    - `/answers/{answerId}`

- `/centers/{centerId}` 
    - `/admins/{adminId}`
    - `/inventory/{inventoryId}` -> automatically created after a verification process once a donation is arrived

- `/offers/{offerId}` -> food offers from distribution centers

- `/productCategories/{productCategoryId}` -> product classifications

- `/voluntaryWorkCategories/{voluntaryWorkCategoryId}` -> service classifications


## User roles
