(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((A(((H[MX])|(M(P|SN))|(X((D[ACH])|(M[DS]))?)))?)|(K7(A)?)|(D(H[DLM])?))(\d{3,4})[ABD-G][CHJK-NPQT-Y][Q-TV][1-4][B-E]$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "A") (re.opt (re.union (re.++ (str.to_re "H") (re.union (str.to_re "M") (str.to_re "X"))) (re.++ (str.to_re "M") (re.union (str.to_re "P") (str.to_re "SN"))) (re.++ (str.to_re "X") (re.opt (re.union (re.++ (str.to_re "D") (re.union (str.to_re "A") (str.to_re "C") (str.to_re "H"))) (re.++ (str.to_re "M") (re.union (str.to_re "D") (str.to_re "S"))))))))) (re.++ (str.to_re "K7") (re.opt (str.to_re "A"))) (re.++ (str.to_re "D") (re.opt (re.++ (str.to_re "H") (re.union (str.to_re "D") (str.to_re "L") (str.to_re "M")))))) ((_ re.loop 3 4) (re.range "0" "9")) (re.union (str.to_re "A") (str.to_re "B") (re.range "D" "G")) (re.union (str.to_re "C") (str.to_re "H") (str.to_re "J") (re.range "K" "N") (str.to_re "P") (str.to_re "Q") (re.range "T" "Y")) (re.union (re.range "Q" "T") (str.to_re "V")) (re.range "1" "4") (re.range "B" "E") (str.to_re "\u{0a}")))))
(check-sat)
