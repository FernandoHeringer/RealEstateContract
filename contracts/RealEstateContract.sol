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
