(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; HWPE[^\n\r]*Basic.*LOGsearches\x2Eworldtostart\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "HWPE") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Basic") (re.* re.allchar) (str.to_re "LOGsearches.worldtostart.com\u{0a}"))))
; ^-?[0-9]\d{0,8}(\.\d{1,4})
(assert (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.range "0" "9") ((_ re.loop 0 8) (re.range "0" "9")) (str.to_re "\u{0a}.") ((_ re.loop 1 4) (re.range "0" "9")))))
(assert (> (str.len X) 10))
(check-sat)
