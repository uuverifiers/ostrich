;test regex ((NO)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{3}|(NO)[0-9A-Z]{13}|(BE)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}|(BE)[0-9A-Z]{14}|(DK|FO|FI|GL|NL)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{2}|(DK|FO|FI|GL|NL)[0-9A-Z]{16}|(MK|SI)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{3}|(MK|SI)[0-9A-Z]{17}|(BA|EE|KZ|LT|LU|AT)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}|(BA|EE|KZ|LT|LU|AT)[0-9A-Z]{18}|(HR|LI|LV|CH)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{1}|(HR|LI|LV|CH)[0-9A-Z]{19}|(BG|DE|IE|ME|RS|GB)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{2}|(BG|DE|IE|ME|RS|GB)[0-9A-Z]{20}|(GI|IL)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{3}|(GI|IL)[0-9A-Z]{21}|(AD|CZ|SA|RO|SK|ES|SE|TN)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}|(AD|CZ|SA|RO|SK|ES|SE|TN)[0-9A-Z]{22}|(PT)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{1}|(PT)[0-9A-Z]{23}|(IS|TR)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{2}|(IS|TR)[0-9A-Z]{24}|(FR|GR|IT|MC|SM)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{3}|(FR|GR|IT|MC|SM)[0-9A-Z]{25}|(AL|CY|HU|LB|PL)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}|(AL|CY|HU|LB|PL)[0-9A-Z]{26}|(MU)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{2}|(MU)[0-9A-Z]{28}|(MT)[0-9A-Z]{2}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{4}[ ][0-9A-Z]{3}|(MT)[0-9A-Z]{29})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (re.++ (str.to_re "N") (str.to_re "O")) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.range "A" "Z")))))))))) (re.++ (re.++ (str.to_re "N") (str.to_re "O")) ((_ re.loop 13 13) (re.union (re.range "0" "9") (re.range "A" "Z"))))) (re.++ (re.++ (str.to_re "B") (str.to_re "E")) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))))))))))) (re.++ (re.++ (str.to_re "B") (str.to_re "E")) ((_ re.loop 14 14) (re.union (re.range "0" "9") (re.range "A" "Z"))))) (re.++ (re.union (re.union (re.union (re.union (re.++ (str.to_re "D") (str.to_re "K")) (re.++ (str.to_re "F") (str.to_re "O"))) (re.++ (str.to_re "F") (str.to_re "I"))) (re.++ (str.to_re "G") (str.to_re "L"))) (re.++ (str.to_re "N") (str.to_re "L"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))))))))))))) (re.++ (re.union (re.union (re.union (re.union (re.++ (str.to_re "D") (str.to_re "K")) (re.++ (str.to_re "F") (str.to_re "O"))) (re.++ (str.to_re "F") (str.to_re "I"))) (re.++ (str.to_re "G") (str.to_re "L"))) (re.++ (str.to_re "N") (str.to_re "L"))) ((_ re.loop 16 16) (re.union (re.range "0" "9") (re.range "A" "Z"))))) (re.++ (re.union (re.++ (str.to_re "M") (str.to_re "K")) (re.++ (str.to_re "S") (str.to_re "I"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.range "A" "Z"))))))))))))) (re.++ (re.union (re.++ (str.to_re "M") (str.to_re "K")) (re.++ (str.to_re "S") (str.to_re "I"))) ((_ re.loop 17 17) (re.union (re.range "0" "9") (re.range "A" "Z"))))) (re.++ (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "B") (str.to_re "A")) (re.++ (str.to_re "E") (str.to_re "E"))) (re.++ (str.to_re "K") (str.to_re "Z"))) (re.++ (str.to_re "L") (str.to_re "T"))) (re.++ (str.to_re "L") (str.to_re "U"))) (re.++ (str.to_re "A") (str.to_re "T"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))))))))))))) (re.++ (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "B") (str.to_re "A")) (re.++ (str.to_re "E") (str.to_re "E"))) (re.++ (str.to_re "K") (str.to_re "Z"))) (re.++ (str.to_re "L") (str.to_re "T"))) (re.++ (str.to_re "L") (str.to_re "U"))) (re.++ (str.to_re "A") (str.to_re "T"))) ((_ re.loop 18 18) (re.union (re.range "0" "9") (re.range "A" "Z"))))) (re.++ (re.union (re.union (re.union (re.++ (str.to_re "H") (str.to_re "R")) (re.++ (str.to_re "L") (str.to_re "I"))) (re.++ (str.to_re "L") (str.to_re "V"))) (re.++ (str.to_re "C") (str.to_re "H"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") ((_ re.loop 1 1) (re.union (re.range "0" "9") (re.range "A" "Z"))))))))))))))) (re.++ (re.union (re.union (re.union (re.++ (str.to_re "H") (str.to_re "R")) (re.++ (str.to_re "L") (str.to_re "I"))) (re.++ (str.to_re "L") (str.to_re "V"))) (re.++ (str.to_re "C") (str.to_re "H"))) ((_ re.loop 19 19) (re.union (re.range "0" "9") (re.range "A" "Z"))))) (re.++ (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "B") (str.to_re "G")) (re.++ (str.to_re "D") (str.to_re "E"))) (re.++ (str.to_re "I") (str.to_re "E"))) (re.++ (str.to_re "M") (str.to_re "E"))) (re.++ (str.to_re "R") (str.to_re "S"))) (re.++ (str.to_re "G") (str.to_re "B"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))))))))))))))) (re.++ (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "B") (str.to_re "G")) (re.++ (str.to_re "D") (str.to_re "E"))) (re.++ (str.to_re "I") (str.to_re "E"))) (re.++ (str.to_re "M") (str.to_re "E"))) (re.++ (str.to_re "R") (str.to_re "S"))) (re.++ (str.to_re "G") (str.to_re "B"))) ((_ re.loop 20 20) (re.union (re.range "0" "9") (re.range "A" "Z"))))) (re.++ (re.union (re.++ (str.to_re "G") (str.to_re "I")) (re.++ (str.to_re "I") (str.to_re "L"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.range "A" "Z"))))))))))))))) (re.++ (re.union (re.++ (str.to_re "G") (str.to_re "I")) (re.++ (str.to_re "I") (str.to_re "L"))) ((_ re.loop 21 21) (re.union (re.range "0" "9") (re.range "A" "Z"))))) (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "A") (str.to_re "D")) (re.++ (str.to_re "C") (str.to_re "Z"))) (re.++ (str.to_re "S") (str.to_re "A"))) (re.++ (str.to_re "R") (str.to_re "O"))) (re.++ (str.to_re "S") (str.to_re "K"))) (re.++ (str.to_re "E") (str.to_re "S"))) (re.++ (str.to_re "S") (str.to_re "E"))) (re.++ (str.to_re "T") (str.to_re "N"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))))))))))))))) (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "A") (str.to_re "D")) (re.++ (str.to_re "C") (str.to_re "Z"))) (re.++ (str.to_re "S") (str.to_re "A"))) (re.++ (str.to_re "R") (str.to_re "O"))) (re.++ (str.to_re "S") (str.to_re "K"))) (re.++ (str.to_re "E") (str.to_re "S"))) (re.++ (str.to_re "S") (str.to_re "E"))) (re.++ (str.to_re "T") (str.to_re "N"))) ((_ re.loop 22 22) (re.union (re.range "0" "9") (re.range "A" "Z"))))) (re.++ (re.++ (str.to_re "P") (str.to_re "T")) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") ((_ re.loop 1 1) (re.union (re.range "0" "9") (re.range "A" "Z"))))))))))))))))) (re.++ (re.++ (str.to_re "P") (str.to_re "T")) ((_ re.loop 23 23) (re.union (re.range "0" "9") (re.range "A" "Z"))))) (re.++ (re.union (re.++ (str.to_re "I") (str.to_re "S")) (re.++ (str.to_re "T") (str.to_re "R"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))))))))))))))))) (re.++ (re.union (re.++ (str.to_re "I") (str.to_re "S")) (re.++ (str.to_re "T") (str.to_re "R"))) ((_ re.loop 24 24) (re.union (re.range "0" "9") (re.range "A" "Z"))))) (re.++ (re.union (re.union (re.union (re.union (re.++ (str.to_re "F") (str.to_re "R")) (re.++ (str.to_re "G") (str.to_re "R"))) (re.++ (str.to_re "I") (str.to_re "T"))) (re.++ (str.to_re "M") (str.to_re "C"))) (re.++ (str.to_re "S") (str.to_re "M"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.range "A" "Z"))))))))))))))))) (re.++ (re.union (re.union (re.union (re.union (re.++ (str.to_re "F") (str.to_re "R")) (re.++ (str.to_re "G") (str.to_re "R"))) (re.++ (str.to_re "I") (str.to_re "T"))) (re.++ (str.to_re "M") (str.to_re "C"))) (re.++ (str.to_re "S") (str.to_re "M"))) ((_ re.loop 25 25) (re.union (re.range "0" "9") (re.range "A" "Z"))))) (re.++ (re.union (re.union (re.union (re.union (re.++ (str.to_re "A") (str.to_re "L")) (re.++ (str.to_re "C") (str.to_re "Y"))) (re.++ (str.to_re "H") (str.to_re "U"))) (re.++ (str.to_re "L") (str.to_re "B"))) (re.++ (str.to_re "P") (str.to_re "L"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))))))))))))))))) (re.++ (re.union (re.union (re.union (re.union (re.++ (str.to_re "A") (str.to_re "L")) (re.++ (str.to_re "C") (str.to_re "Y"))) (re.++ (str.to_re "H") (str.to_re "U"))) (re.++ (str.to_re "L") (str.to_re "B"))) (re.++ (str.to_re "P") (str.to_re "L"))) ((_ re.loop 26 26) (re.union (re.range "0" "9") (re.range "A" "Z"))))) (re.++ (re.++ (str.to_re "M") (str.to_re "U")) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))))))))))))))))))) (re.++ (re.++ (str.to_re "M") (str.to_re "U")) ((_ re.loop 28 28) (re.union (re.range "0" "9") (re.range "A" "Z"))))) (re.++ (re.++ (str.to_re "M") (str.to_re "T")) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.range "A" "Z"))))))))))))))))))) (re.++ (re.++ (str.to_re "M") (str.to_re "T")) ((_ re.loop 29 29) (re.union (re.range "0" "9") (re.range "A" "Z")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)