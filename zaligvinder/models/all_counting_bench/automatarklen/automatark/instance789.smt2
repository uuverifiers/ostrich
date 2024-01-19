(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; rank\x2Etoolbarbrowser\x2Ecomlnzzlnbk\u{2f}pkrm\.fin
(assert (not (str.in_re X (str.to_re "rank.toolbarbrowser.comlnzzlnbk/pkrm.fin\u{0a}"))))
; ^([A-HJ-PR-Y]{2,2}[056][0-9]\s?[A-HJ-PR-Y]{3,3})$|^([A-HJ-NP-Y]{1,3}[0-9]{2,3}?\s[A-Z]{3,3})$|^([A-Z]{1,3}\s?[0-9]{1,4}([A-Z]{1,1})?)$|^([0-9]{4,4}[A-Z]{1,3})$|^([A-Z]{1,2}\s?[0-9]{1,4})$|^([A-Z]{2,3}\s?[0-9]{1,4})$|^([0-9]{1,4}\s?[A-Z]{2,3})$
(assert (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "H") (re.range "J" "P") (re.range "R" "Y"))) (re.union (str.to_re "0") (str.to_re "5") (str.to_re "6")) (re.range "0" "9") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.union (re.range "A" "H") (re.range "J" "P") (re.range "R" "Y")))) (re.++ ((_ re.loop 1 3) (re.union (re.range "A" "H") (re.range "J" "N") (re.range "P" "Y"))) ((_ re.loop 2 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 3 3) (re.range "A" "Z"))) (re.++ ((_ re.loop 1 3) (re.range "A" "Z")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 4) (re.range "0" "9")) (re.opt ((_ re.loop 1 1) (re.range "A" "Z")))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 1 3) (re.range "A" "Z"))) (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 4) (re.range "0" "9"))) (re.++ ((_ re.loop 2 3) (re.range "A" "Z")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 4) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 4) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 3) (re.range "A" "Z"))))))
; /\u{2e}jpf([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.jpf") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; Host\u{3a}\s+Host\x3A\x2Ftoolbar\x2Fsupremetb
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:/toolbar/supremetb\u{0a}")))))
; HWAE\s+\x2Fta\x2FNEWS\x2FGuptacharloomcompany\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "HWAE") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/ta/NEWS/Guptacharloomcompany.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
