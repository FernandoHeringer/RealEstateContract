// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

contract RealEstate {
    // Owner of the contract (admin or platform operator)
    address public owner;

     // Structure to represent a property
    struct Property {
        uint propertyId; // Unique ID for the property
        string description; // Property description (e.g., "2BHK Apartment in Downtown")
        uint price; // Property price in wei (smallest unit of Ether)
        address payable seller; // Address of the seller
        address buyer; // Address of the buyer (if sold)
        bool isSold; // Status of the property
    }

  // Mapping to store properties by their ID
    mapping(uint => Property) public properties;

    // Counter for property IDs
    uint public propertyCount;

    // Event declarations
    event PropertyListed(uint propertyId, string description, uint price, address seller);
    event PropertySold(uint propertyId, address buyer, uint price);
    event PaymentReleased(uint propertyId, address seller, uint price);

    // Modifier to restrict functions to the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action.");
        _;
    }

 // Modifier to restrict functions to the property seller
    modifier onlySeller(uint _propertyId) {
        require(properties[_propertyId].seller == msg.sender, "Only the seller can perform this action.");
        _;
    }

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Function to list a property
    function listProperty(string memory _description, uint _price) public {
        require(_price > 0, "Price must be greater than zero.");

        // Create a new property and add it to the mapping
        properties[propertyCount] = Property(
            propertyCount,
            _description,
            _price,
            payable(msg.sender),
            address(0),
            false
        );

        emit PropertyListed(propertyCount, _description, _price, msg.sender);

        propertyCount++;
    }

      // Function to buy a property
    function buyProperty(uint _propertyId) public payable {
        require(_propertyId < propertyCount, "Invalid property ID.");
        Property storage property = properties[_propertyId];

        require(!property.isSold, "Property already sold.");
        require(msg.value == property.price, "Incorrect payment amount.");
        require(property.seller != msg.sender, "Seller cannot buy their own property.");

        // Transfer ownership to the buyer
        property.buyer = msg.sender;
        property.isSold = true;

        emit PropertySold(_propertyId, msg.sender, property.price);
    }

// Function to release payment to the seller
    function releasePayment(uint _propertyId) public onlySeller(_propertyId) {
        Property storage property = properties[_propertyId];

        require(property.isSold, "Property is not sold yet.");
        require(property.buyer != address(0), "No buyer for this property.");

        uint amount = property.price;
        property.seller.transfer(amount);

        emit PaymentReleased(_propertyId, property.seller, amount);
    }

      // Function to get property details
    function getPropertyDetails(uint _propertyId)
        public
        view
        returns (
            string memory description,
            uint price,
            address seller,
            address buyer,
            bool isSold
        )
    {
      require(_propertyId < propertyCount, "Invalid property ID.");
        Property memory property = properties[_propertyId];
        return (property.description, property.price, property.seller, property.buyer, property.isSold);
    }
}