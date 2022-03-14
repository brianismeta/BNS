// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract BNS {
    event AddrChanged(string indexed node, address indexed a);

    struct Record {
        string bns;
        address addr;
        bool adminset;
        uint blocknumber;
        uint blocktime;
        uint index;
    }

    Record[] Records;

    address owner;
    mapping(string=>address) bns2addr_map;
    // because it is free, we want to limit one .bns address to each ETH address
    // so basically a 1:1 relationship
    // also we want to make sure that only the owner of the account can associate a .bns address
    mapping(address=>string) addr2bns_map;

    // require that the bns string be lowercase, numbers or dash (-), and end with .bns
    modifier only_allowed_characters(string memory node) {
        require(_checkAllowableCharacters(node),"bns address has invalid characters!");
        _;
    }
    // require that the bns string be between 5-32 characters
    modifier only_allowed_length(string memory node) {
        uint len = bytes(node).length;
        require (len <= 32,"bns address too long!");
        // example, must be at least one character followed by ".bns"
        require (len >= 5, "bns address too short!");
        _;
    }
    
    modifier only_owner() {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function resolve(string memory node) public 
        only_allowed_characters(node) 
        only_allowed_length(node) 
        view returns(address) 
    {
        address ret = bns2addr_map[node];
        require(ret != address(0), "bns address not found!");
        return ret;    
    }

    function set(string memory node) public 
        only_allowed_characters(node) 
        only_allowed_length(node) 
    {
        string memory bns = addr2bns_map[msg.sender];
        require(bytes(bns).length == 0,"accounts can only map to one bns address!");
        bns2addr_map[node] = msg.sender;
        addr2bns_map[msg.sender] = node;
        Records.push(Record(node,msg.sender,false,block.number,block.timestamp,Records.length));

        emit AddrChanged(node, msg.sender);
    }
    function clear() public
    {
        string memory bns = addr2bns_map[msg.sender];
        require(bytes(bns).length > 0,"bns address not found!");
        bns2addr_map[bns] = address(0);
        addr2bns_map[msg.sender] = "";
        emit AddrChanged("", msg.sender);
    }

    function admin_set(string memory node, address addr) public 
        only_owner 
        only_allowed_characters(node) 
        only_allowed_length(node) 
    {
        // if a mapping already exists, need to clear the reverse one!
        string memory bns = addr2bns_map[addr];
        if (bytes(bns).length > 0) {
            bns2addr_map[bns] = address(0);
        }

        bns2addr_map[node] = addr;
        addr2bns_map[addr] = node;
        Records.push(Record(node,addr,true,block.number,block.timestamp,Records.length));

        emit AddrChanged(node, addr);
    }

// View returns a set of historical records based on start time and end time.
// View will only return up to 20 records, and suggest whether there could be more.
// 'burn' is used to page through the results, set burn to 20 to get to the next 20 records.
// First group of records search time is O(n) but will be improved later to O(log n)
// Use of 'burn' to page through a large number of records will also end up giving poor
// performance of O(n).  Instead the caller should use a newer 'starttime' in combination
// with 'burn' to improve performance to O(log n) after later improvements.
    function View(uint starttime, uint endtime, uint burn) public view 
    returns ( 
        uint ,// numrecords,
        bool ,// lastpage,
        // removed due to Solidity limitations - can not return an array of strings
        //string[] memory _bns,// bns,
        string memory , // comma-delimited bns addresses! to workaround Solidity limitation
        address[] memory,// addr,
        // removed due to 'stack too deep'
        //bool[] memory ,// adminset,
        uint[] memory ,// blocknumber,
        uint[] memory //,// blocktime,
        // removed due to 'stack too deep'
        //uint[] memory // index
    ) {

        // BECAUSE OF 'STACK TOO DEEP' HAD TO REMOVE SOME
        // VARIABLES.
        uint _pushed = 0;
        // removed due to 'stack too deep'
        //bool _lastPage = true;
        string memory _bns_csv;
        address[] memory _addr = new address[](20);
        // removed due to 'stack too deep'
        //bool[] memory _adminset = new bool[](20);
        uint[] memory _blocknumber = new uint[](20);
        uint[] memory _blocktime = new uint[](20);
        // removed due to 'stack too deep'
        //uint[] memory _index = new uint[](20);

        uint rec = Records.length;

        require(rec > 0, "no records yet!");

        // only return up to 20 records...
        // This is interim implementation - poor performance when Records increases O(n)
        // Switch to binary search - Find first record O(log n) and then get next 20 or less
        for (uint i=0; ((i<rec) && (_pushed < 20 ) ); i++) {
            // removed due to 'stack too deep'
            //Record memory r = Records[i];
            if ((Records[i].blocktime >= starttime) && (Records[i].blocktime <= endtime)) {
                if (burn > 0) {
                    // skip the first 'burn' number of records
                    burn = burn -1;
                } else {
                    if (_pushed == 20) {
                        // we already pushed 20 records
                        break; //_lastPage = false;
                    } else {
                        // create comma-delimited string to workaround Solidity limitation
                        if (_pushed == 0) {
                            _bns_csv = Records[i].bns;
                        } else {
                            _bns_csv = string(abi.encodePacked(_bns_csv,",",Records[i].bns));
                        }

                        _addr[_pushed] = Records[i].addr;
                        //_adminset[_pushed] = Records[i].adminset;
                        _blocknumber[_pushed] = Records[i].blocknumber;
                        _blocktime[_pushed] = Records[i].blocktime;
                        //_index[_pushed] = Records[i].index;
                        _pushed = _pushed +1;
                    }
                }
            }
        }
        return ( _pushed, (_pushed == 20), //_lastPage, 
            _bns_csv, 
            _addr, 
            //_adminset, 
            _blocknumber, _blocktime
            //, _index 
            );
    }
    // only allow lowercase a-z, 0-9, and the hyphen (-) character
    // must end with '.bns'
    function _checkAllowableCharacters(string memory str) internal pure returns (bool Allowed) {
        //bool Allowed = true;
        bytes memory bStr = bytes(str);
        uint len = bStr.length;
        // just in case order of modifiers is switched, need to make sure length is at least 5
        require(len >=5,"bns address is too short!");
        for (uint i = 0; i < len - 4; i++) {
            if ((uint8(bStr[i]) >= 97) && (uint8(bStr[i]) <= 122)) {
                // lowercase characters...
            } else if ((uint8(bStr[i]) >= 48) && (uint8(bStr[i]) <= 57)) {
                // numbers...
            } else if (uint8(bStr[i]) == 45) {
                // dash...    
            } else {
                // invalid
                return false;
            }
        }
        // check for the last four characters --- must be ".bns" !
        if (uint8(bStr[len-4]) != 46) {
            return false;
        }
        if (uint8(bStr[len-3]) != 98) {
            return false;
        }
        if (uint8(bStr[len-2]) != 110) {
            return false;
        }
        if (uint8(bStr[len-1]) != 115) {
            return false;
        }

        return true;
    }

}
