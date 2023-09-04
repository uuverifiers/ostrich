(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ppcdomain\x2Eco\x2EukBasic
(assert (str.in_re X (str.to_re "ppcdomain.co.ukBasic\u{0a}")))
; /filename\s*=\s*[^\r\n]*?\u{2e}ttf[\u{22}\u{27}\u{3b}\s\r\n]/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re ".ttf") (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ";") (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/i\u{0a}")))))
; upgrade\x2Eqsrch\x2Einfo[^\n\r]*dcww\x2Edmcast\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "upgrade.qsrch.info") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "dcww.dmcast.com\u{0a}")))))
; (((^[BEGLMNS][1-9]\d?) | (^W[2-9] ) | ( ^( A[BL] | B[ABDHLNRST] | C[ABFHMORTVW] | D[ADEGHLNTY] | E[HNX] | F[KY] | G[LUY] | H[ADGPRSUX] | I[GMPV] | JE | K[ATWY] | L[ADELNSU] | M[EKL] | N[EGNPRW] | O[LX] | P[AEHLOR] | R[GHM] | S[AEGKL-PRSTWY] | T[ADFNQRSW] | UB | W[ADFNRSV] | YO | ZE ) \d\d?) | (^W1[A-HJKSTUW0-9]) | ((  (^WC[1-2])  |  (^EC[1-4]) | (^SW1)  ) [ABEHMNPRVWXY] ) ) (\s*)?  ([0-9][ABD-HJLNP-UW-Z]{2})) | (^GIR\s?0AA)
(assert (not (str.in_re X (re.union (re.++ (str.to_re " ") (re.union (re.++ (str.to_re " ") (re.union (str.to_re "B") (str.to_re "E") (str.to_re "G") (str.to_re "L") (str.to_re "M") (str.to_re "N") (str.to_re "S")) (re.range "1" "9") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "  W") (re.range "2" "9") (str.to_re " ")) (re.++ (str.to_re "    ") (re.range "0" "9") (re.opt (re.range "0" "9")) (str.to_re " ") (re.union (re.++ (str.to_re "A") (re.union (str.to_re "B") (str.to_re "L")) (str.to_re " ")) (re.++ (str.to_re "B") (re.union (str.to_re "A") (str.to_re "B") (str.to_re "D") (str.to_re "H") (str.to_re "L") (str.to_re "N") (str.to_re "R") (str.to_re "S") (str.to_re "T")) (str.to_re " ")) (re.++ (str.to_re "C") (re.union (str.to_re "A") (str.to_re "B") (str.to_re "F") (str.to_re "H") (str.to_re "M") (str.to_re "O") (str.to_re "R") (str.to_re "T") (str.to_re "V") (str.to_re "W")) (str.to_re " ")) (re.++ (str.to_re "D") (re.union (str.to_re "A") (str.to_re "D") (str.to_re "E") (str.to_re "G") (str.to_re "H") (str.to_re "L") (str.to_re "N") (str.to_re "T") (str.to_re "Y")) (str.to_re " ")) (re.++ (str.to_re "E") (re.union (str.to_re "H") (str.to_re "N") (str.to_re "X")) (str.to_re " ")) (re.++ (str.to_re "F") (re.union (str.to_re "K") (str.to_re "Y")) (str.to_re " ")) (re.++ (str.to_re "G") (re.union (str.to_re "L") (str.to_re "U") (str.to_re "Y")) (str.to_re " ")) (re.++ (str.to_re "H") (re.union (str.to_re "A") (str.to_re "D") (str.to_re "G") (str.to_re "P") (str.to_re "R") (str.to_re "S") (str.to_re "U") (str.to_re "X")) (str.to_re " ")) (re.++ (str.to_re "I") (re.union (str.to_re "G") (str.to_re "M") (str.to_re "P") (str.to_re "V")) (str.to_re " ")) (str.to_re "JE ") (re.++ (str.to_re "K") (re.union (str.to_re "A") (str.to_re "T") (str.to_re "W") (str.to_re "Y")) (str.to_re " ")) (re.++ (str.to_re "L") (re.union (str.to_re "A") (str.to_re "D") (str.to_re "E") (str.to_re "L") (str.to_re "N") (str.to_re "S") (str.to_re "U")) (str.to_re " ")) (re.++ (str.to_re "M") (re.union (str.to_re "E") (str.to_re "K") (str.to_re "L")) (str.to_re " ")) (re.++ (str.to_re "N") (re.union (str.to_re "E") (str.to_re "G") (str.to_re "N") (str.to_re "P") (str.to_re "R") (str.to_re "W")) (str.to_re " ")) (re.++ (str.to_re "O") (re.union (str.to_re "L") (str.to_re "X")) (str.to_re " ")) (re.++ (str.to_re "P") (re.union (str.to_re "A") (str.to_re "E") (str.to_re "H") (str.to_re "L") (str.to_re "O") (str.to_re "R")) (str.to_re " ")) (re.++ (str.to_re "R") (re.union (str.to_re "G") (str.to_re "H") (str.to_re "M")) (str.to_re " ")) (re.++ (str.to_re "S") (re.union (str.to_re "A") (str.to_re "E") (str.to_re "G") (str.to_re "K") (re.range "L" "P") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "W") (str.to_re "Y")) (str.to_re " ")) (re.++ (str.to_re "T") (re.union (str.to_re "A") (str.to_re "D") (str.to_re "F") (str.to_re "N") (str.to_re "Q") (str.to_re "R") (str.to_re "S") (str.to_re "W")) (str.to_re " ")) (str.to_re "UB ") (re.++ (str.to_re "W") (re.union (str.to_re "A") (str.to_re "D") (str.to_re "F") (str.to_re "N") (str.to_re "R") (str.to_re "S") (str.to_re "V")) (str.to_re " ")) (str.to_re "YO ") (str.to_re "ZE "))) (re.++ (str.to_re "  W1") (re.union (re.range "A" "H") (str.to_re "J") (str.to_re "K") (str.to_re "S") (str.to_re "T") (str.to_re "U") (str.to_re "W") (re.range "0" "9"))) (re.++ (str.to_re "   ") (re.union (str.to_re "A") (str.to_re "B") (str.to_re "E") (str.to_re "H") (str.to_re "M") (str.to_re "N") (str.to_re "P") (str.to_re "R") (str.to_re "V") (str.to_re "W") (str.to_re "X") (str.to_re "Y")) (str.to_re "  ") (re.union (re.++ (str.to_re "   WC") (re.range "1" "2")) (re.++ (str.to_re "  EC") (re.range "1" "4")) (str.to_re "SW1  ")))) (str.to_re " ") (re.opt (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "  ") (re.range "0" "9") ((_ re.loop 2 2) (re.union (str.to_re "A") (str.to_re "B") (re.range "D" "H") (str.to_re "J") (str.to_re "L") (str.to_re "N") (re.range "P" "U") (re.range "W" "Z")))) (re.++ (str.to_re " \u{0a}GIR") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "0AA"))))))
; /\/3\/[A-Z]{2}\/[a-f0-9]{32}\.djvu/
(assert (str.in_re X (re.++ (str.to_re "//3/") ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".djvu/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)