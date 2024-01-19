(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z]{1,2}[0-9][0-9A-Za-z]{0,1} {0,1}[0-9][A-Za-z]{2}$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.range "0" "9") (re.opt (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z"))) (re.opt (str.to_re " ")) (re.range "0" "9") ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}"))))
; PASSW=\s+\x2Fta\x2FNEWS\x2F.*loomcompany\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "PASSW=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/ta/NEWS/") (re.* re.allchar) (str.to_re "loomcompany.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
