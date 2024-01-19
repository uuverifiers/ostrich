(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[ \t]+|[ \t]+$
(assert (not (str.in_re X (re.union (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}"))) (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}"))) (str.to_re "\u{0a}"))))))
; logs\s+TCP.*Toolbarads\.grokads\.com
(assert (not (str.in_re X (re.++ (str.to_re "logs") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "TCP") (re.* re.allchar) (str.to_re "Toolbarads.grokads.com\u{0a}")))))
; User-Agent\u{3a}\s+Host\x3A\s+proxystylesheet=Excitefhfksjzsfu\u{2f}ahm\.uqs
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "proxystylesheet=Excitefhfksjzsfu/ahm.uqs\u{0a}")))))
; www\x2Ericercadoppia\x2Ecom\w+TPSystem\s+User-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "www.ricercadoppia.com") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "TPSystem") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:\u{0a}"))))
; ^((A(((H[MX])|(M(P|SN))|(X((D[ACH])|(M[DS]))?)))?)|(K7(A)?)|(D(H[DLM])?))(\d{3,4})[ABD-G][CHJK-NPQT-Y][Q-TV][1-4][B-E]$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "A") (re.opt (re.union (re.++ (str.to_re "H") (re.union (str.to_re "M") (str.to_re "X"))) (re.++ (str.to_re "M") (re.union (str.to_re "P") (str.to_re "SN"))) (re.++ (str.to_re "X") (re.opt (re.union (re.++ (str.to_re "D") (re.union (str.to_re "A") (str.to_re "C") (str.to_re "H"))) (re.++ (str.to_re "M") (re.union (str.to_re "D") (str.to_re "S"))))))))) (re.++ (str.to_re "K7") (re.opt (str.to_re "A"))) (re.++ (str.to_re "D") (re.opt (re.++ (str.to_re "H") (re.union (str.to_re "D") (str.to_re "L") (str.to_re "M")))))) ((_ re.loop 3 4) (re.range "0" "9")) (re.union (str.to_re "A") (str.to_re "B") (re.range "D" "G")) (re.union (str.to_re "C") (str.to_re "H") (str.to_re "J") (re.range "K" "N") (str.to_re "P") (str.to_re "Q") (re.range "T" "Y")) (re.union (re.range "Q" "T") (str.to_re "V")) (re.range "1" "4") (re.range "B" "E") (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
