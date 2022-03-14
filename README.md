# BNS
Better Name Service

Refer to the Medium article I wrote, https://link.medium.com/NXufhVnyob

The goals of the “Better Name Service” concept is to address issues in the designs and governance of current systems, and to provide an alternative.

BNS will provide a free-to-use registration system, transparent registrations, and ability to review/revoke registrations.

Issue #1: Lack of transparency of the names being registered.

Blockchains are built upon concepts of transparency, however current systems are far less than transparent.

In current systems, 1-way hashes are used which hide the original name from scrutiny, potentially giving safe harbor to a wide range of entities of ill-repute. Only upon happenstance discovery, the community may discover names that were registered that not only violate human decency, but could effectively be criminal.

Solution:
BNS seeks to make this better by:
• providing external parameterized functions that will take strings for the .bns name in registrations and lookups

In this way, new registrations can be monitored and the BNS community can take action if there are .bns names being registered that violate community guidelines.

Issue #2: Historical / audit logs are non-existent

Although blockchains keeps an immutable record of all transactions in a sequence of blocks that date back to the beginning, consumers of this data generally have to turn to analytics platforms like Etherscan.io, in order to extract useful data from it. Decentralized application (dApp) developers are “freed” from the burden of having to provide even the simplest of external functions that search for data, or provide a history because they point to the blockchains itself as its “log”, which puts the burden back on the user to interact with analytic platforms.

Solution:
BNS believes that all applications should be responsible for providing reasonable insights into its data by exposing search and historical data, using available capabilities of smart contract development. This makes the name service more friendly and consumable by other services. BNS therefore proposes the ability to:
• search for previous registrations and changes of a .bns address,
• retrieve a paged dataset of records between two date stamps / block numbers, and
• listen for an event for new registrations / changes as they occur

Issue #3: Copying irrelevant DNS design

The design of other name services seem to take their design cues from Internet’s Domain Name Services (DNS), and may have gone too far in this case. Getting the right address for a recipient of cryptocurrency, tokens, NFTs, etc., cannot be understated. BNS suggests consumers to query for the correct name resolution as they need it, and leaves it up to the consumer to cache names at their own legal risk. Note that blockchain transactions are immutable and irreversible.

Solution:
BNS does not provide a TTL (Time To Live).

Issue #4: Non-stop Twitter drama

Logging on to Twitter, one will get their daily dose of drama surrounding other name services. Although blockchain, smart contracts, and DAOs are touted as the panacea to centralized corporate greed and malfeasance, in the end humans are still in charge of these, and are imperfect. A new name service without all the drama has to rise from these ashes.

Solution:
BNS recognizes the need for community moderation of the .bns registrations, the ability for users of the system to flag unwanted .bns addresses, and for a trusted review team to make decisions on whether to revoke registrations.
