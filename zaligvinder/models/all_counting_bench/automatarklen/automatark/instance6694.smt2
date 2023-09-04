(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}m4v/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".m4v/i\u{0a}"))))
; ([AEHKLTY][ABEHKLMPRSTWXYZ]|B[ABEHKLMT]|C[ABEHKLR]|GY|[JS][ABCEGHJKLMNPRSTWXYZ]|M[AWX]|N[ABEHLMPRSWXYZ]|O[ABEHKLMPRSX]|P[ABCEGHJKLMNPRSTWXY]|R[ABEHKMPRSTWXYZ]|W[ABEKLMP]|Z[ABEHKLMPRSTWXY])[0-9]{6}[A-D]?
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "A") (str.to_re "E") (str.to_re "H") (str.to_re "K") (str.to_re "L") (str.to_re "T") (str.to_re "Y")) (re.union (str.to_re "A") (str.to_re "B") (str.to_re "E") (str.to_re "H") (str.to_re "K") (str.to_re "L") (str.to_re "M") (str.to_re "P") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "W") (str.to_re "X") (str.to_re "Y") (str.to_re "Z"))) (re.++ (str.to_re "B") (re.union (str.to_re "A") (str.to_re "B") (str.to_re "E") (str.to_re "H") (str.to_re "K") (str.to_re "L") (str.to_re "M") (str.to_re "T"))) (re.++ (str.to_re "C") (re.union (str.to_re "A") (str.to_re "B") (str.to_re "E") (str.to_re "H") (str.to_re "K") (str.to_re "L") (str.to_re "R"))) (str.to_re "GY") (re.++ (re.union (str.to_re "J") (str.to_re "S")) (re.union (str.to_re "A") (str.to_re "B") (str.to_re "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (str.to_re "J") (str.to_re "K") (str.to_re "L") (str.to_re "M") (str.to_re "N") (str.to_re "P") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "W") (str.to_re "X") (str.to_re "Y") (str.to_re "Z"))) (re.++ (str.to_re "M") (re.union (str.to_re "A") (str.to_re "W") (str.to_re "X"))) (re.++ (str.to_re "N") (re.union (str.to_re "A") (str.to_re "B") (str.to_re "E") (str.to_re "H") (str.to_re "L") (str.to_re "M") (str.to_re "P") (str.to_re "R") (str.to_re "S") (str.to_re "W") (str.to_re "X") (str.to_re "Y") (str.to_re "Z"))) (re.++ (str.to_re "O") (re.union (str.to_re "A") (str.to_re "B") (str.to_re "E") (str.to_re "H") (str.to_re "K") (str.to_re "L") (str.to_re "M") (str.to_re "P") (str.to_re "R") (str.to_re "S") (str.to_re "X"))) (re.++ (str.to_re "P") (re.union (str.to_re "A") (str.to_re "B") (str.to_re "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (str.to_re "J") (str.to_re "K") (str.to_re "L") (str.to_re "M") (str.to_re "N") (str.to_re "P") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "W") (str.to_re "X") (str.to_re "Y"))) (re.++ (str.to_re "R") (re.union (str.to_re "A") (str.to_re "B") (str.to_re "E") (str.to_re "H") (str.to_re "K") (str.to_re "M") (str.to_re "P") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "W") (str.to_re "X") (str.to_re "Y") (str.to_re "Z"))) (re.++ (str.to_re "W") (re.union (str.to_re "A") (str.to_re "B") (str.to_re "E") (str.to_re "K") (str.to_re "L") (str.to_re "M") (str.to_re "P"))) (re.++ (str.to_re "Z") (re.union (str.to_re "A") (str.to_re "B") (str.to_re "E") (str.to_re "H") (str.to_re "K") (str.to_re "L") (str.to_re "M") (str.to_re "P") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "W") (str.to_re "X") (str.to_re "Y")))) ((_ re.loop 6 6) (re.range "0" "9")) (re.opt (re.range "A" "D")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}rt/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rt/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)