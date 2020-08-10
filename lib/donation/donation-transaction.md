# donation transaction

## scheme 1: donor -> collector -> center

|Number|Description|Database operation|BloC event|Role|
|---|---|---|---|---|
|1.|Donor first lists his donation.|**create** `Donation`|initial state|Donor|
|2.|Donation gets assigned to a Distribution center, for MVP the nearest is chosen automatically. See Issue [#2](https://github.com/minga-app/minga_shared/issues/2)|**update** set fields `Donation.centerRef`, `Donation.centerAdmins`|`DonationCenterAssignedEvent`|Donor / Minga Admin, Cloud function automated|
|3.|It gets determined if Donation needs a delivery service, which will in case it's needed be opened for application.|**update** set fields `Donation.needsDeliveryService`, `Donation.deliveryServiceRef`, **create** associated `Service`|`DonationNeedsDeliveryServiceEvent`|Cloud function, via Donor / Minga Admin|
|4. (optional)|Service applications closed, collector is now assigned.|**update** set field Donation.collectorRef, **update** associated `Service`|`DonationDeliveryServiceStaffedEvent`|Cloud function, after Center Admin or Minga Admin accepted collector|
|5. (optional)|Collector confirms pick up, therefore verifies that donation exists.|**update** set field `Service.started`|`DonationPickedUpEvent`|Collector|
|6. (optional)|Collector confirms delivery.|**update** set field `Service.finished`|`DonationDeliveredEvent`|Collector|
|7.|Center verifies that the donation was delivered. Point payout for donor and collector (optional) takes place|*update* set fields `Donation.deliveryVerified`, `Service.verified` |`DonationDeliveryVerifiedEvent`|(Minga Admin /) Center Admin|
