// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.22 <0.9.0;

contract SupplyChain {
    uint32 public product_id = 0; // product id
    uint32 public participant_id = 0; // participant id
    uint32 public ownership_id = 0; // ownership id

    struct product {
        string name;
        string modelNumber;
        string partNumber;
        string serialNumber;
        address productOwner;
        uint32 price;
        uint32 mfgTimeStamp; // manufacturing timestamp
    }
    mapping(uint32 => product) public products; // mapping of product id to product

    struct participant {
        string userName;
        string password;
        address participantAddress;
        uint32 participantType; // 0: producer, 1: distributor, 2: retailer, 3: consumer
    }
    mapping (uint32 => participant) public participants; // mapping of participant id to participant

    struct ownership {
        uint32 product_id;
        uint32 owner_id;
        uint32 transferTimeStamp; // transfer timestamp
        address productOwner;
    }
    mapping (uint32 => ownership) public ownerships; // mapping of ownership id to ownership
    mapping (uint32 => uint32[]) public productOwnerships; // mapping of product id to ownership ids, i.e. track history of ownerships

    event TransferOwnership(uint32 productId);

    function addParticipant(string memory _userName, string memory _password, address _participantAddress, uint32 _participantType)
    public
    returns (uint32)
    {
        uint32 _participant_id = participant_id++;
        participants[participant_id] = participant(_userName, _password, _participantAddress, _participantType);

        return _participant_id;
    }

    function getParticipant(uint32 _participant_id) public view returns (string memory, address, uint32) {
        return (participants[_participant_id].userName, participants[_participant_id].participantAddress, participants[_participant_id].participantType);
    }

    modifier onlyOwner(uint32 _product_id) {
        require(msg.sender == products[_product_id].productOwner, "Only owner can call this function");
        _;
    }

    function addProduct(uint32 _owner_id, string memory _name, string memory _modelNumber, string memory _partNumber, string memory _serialNumber, uint32 _price)
    public
    returns (uint32)
    {
        if(participants[_owner_id].participantType != 0) {
            revert("Only producers can add products");
        }

        uint32 _product_id = product_id++;
        products[_product_id] = product(_name, _modelNumber, _partNumber, _serialNumber, participants[_owner_id].participantAddress, _price, uint32(block.timestamp));

        return _product_id;
    }

    function getProduct(uint32 _product_id) public view returns (string memory, string memory, string memory, string memory, address, uint32, uint32) {
        return (products[_product_id].name, products[_product_id].modelNumber, products[_product_id].partNumber, products[_product_id].serialNumber, products[_product_id].productOwner, products[_product_id].price, products[_product_id].mfgTimeStamp);
    }

    function newOwnership(uint32 _previousOwnerId, uint32 _newOwnerId, uint32 _productId) onlyOwner(_productId)
    public
    returns (bool)
    {
        participant memory _previousOwner = participants[_previousOwnerId];
        participant memory _newOwner = participants[_newOwnerId];
        uint32 _ownership_id = ownership_id++;

        if(_previousOwner.participantType > _newOwner.participantType) {
            revert("Cannot transfer ownership backwards");
        }

        if (_previousOwner.participantType == 0 && _newOwner.participantType != 1) {
            revert("Producers can only transfer ownership to distributors");
        }

        if (_previousOwner.participantType == 1 && _newOwner.participantType != 2) {
            revert("Distributors can only transfer ownership to retailers");
        }

        if (_previousOwner.participantType == 2 && _newOwner.participantType != 3) {
            revert("Retailers can only transfer ownership to consumers");
        }

        if (_previousOwner.participantType == 3) {
            revert("Consumers cannot transfer ownership");
        }

        ownerships[_ownership_id] = ownership(_productId, _newOwnerId, uint32(block.timestamp), _newOwner.participantAddress);
        products[_productId].productOwner = _newOwner.participantAddress;
        productOwnerships[_productId].push(_ownership_id);

        emit TransferOwnership(_productId);

        return true;
    }

    function getProvenance(uint32 _productId) external view returns (uint32[] memory) {
        return productOwnerships[_productId];
    }

    function getOwnership(uint32 _ownershipId) external view returns (uint32, uint32, uint32, address) {
        ownership memory _ownership = ownerships[_ownershipId];

        return (_ownership.product_id, _ownership.owner_id, _ownership.transferTimeStamp, _ownership.productOwner);
    }

    // not secure, only for this pet project
    function authenticateParticipant(uint32 _participantId, string memory _username, string memory _password, string memory _participantType)
    public
    view
    returns (bool)
    {
        if (keccak256(abi.encodePacked(participants[_participantId].userName)) == keccak256(abi.encodePacked(_username)) &&
            keccak256(abi.encodePacked(participants[_participantId].password)) == keccak256(abi.encodePacked(_password)) &&
            keccak256(abi.encodePacked(participants[_participantId].participantType)) == keccak256(abi.encodePacked(_participantType))) {
            return true;
        }

        return false;
    }
}
