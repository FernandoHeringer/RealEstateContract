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