(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-z0-9][a-z0-9_\.-]{0,}[a-z0-9]@[a-z0-9][a-z0-9_\.-]{0,}[a-z0-9][\.][a-z0-9]{2,4}$
(assert (not (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re ".") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "0" "9")) (str.to_re "@") (re.union (re.range "a" "z") (re.range "0" "9")) (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re ".") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; Host\x3A\s+www\.iggsey\.comcs\x2Esmartshopper\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.iggsey.comcs.smartshopper.com\u{0a}")))))
; ^[$]?[0-9]*(\.)?[0-9]?[0-9]?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (str.to_re "\u{0a}")))))
; User-Agent\x3Aetbuviaebe\u{2f}eqv\.bvv
(assert (not (str.in_re X (str.to_re "User-Agent:etbuviaebe/eqv.bvv\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
