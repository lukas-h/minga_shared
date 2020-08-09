# donation transaction

## scheme 1: donor -> collector -> center

|Number|Database operation|BloC event|Role|
|---|---|---|---|
|1.|**create** `Donation`|initial state|Donor|
|2.|**update** set fields `Donation.centerRef`, `Donation.centerAdmins`|`DonationCenterAssignedEvent`|Donor / Minga Admin, maybe via Cloud function|
|3. (optional)|**update** set fields `Donation.needsDeliveryService`, `Donation.deliveryServiceRef`, **create** associated `Service`|
`DonationNeedsDeliveryServiceEvent`|Cloud function, via Donor / Minga Admin|
|4. (optional)|**update** set field Donation.collectorRef, **update** associated `Service`|`DonationDeliveryServiceStaffedEvent`|Cloud function, after Center Admin or Minga Admin accepted collector|
|5. (optional)|**update** set field `Service.started`|`DonationPickedUpEvent`|Collector|
|6. (optional)|**update** set field `Service.finished`|`DonationDeliveredEvent`|Collector|
|7.|*update* set fields `Donation.deliveryVerified`, `Service.verified` |`DonationDeliveryVerifiedEvent`|(Minga Admin /) Center Admin|
