(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (([A-Za-z0-9_\\-]+\\.?)*)[A-Za-z0-9_\\-]+\\.[A-Za-z0-9_\\-]{2,6}
(assert (str.in_re X (re.++ (re.* (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re "\u{5c}") (str.to_re "-"))) (str.to_re "\u{5c}") (re.opt re.allchar))) (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re "\u{5c}") (str.to_re "-"))) (str.to_re "\u{5c}") re.allchar ((_ re.loop 2 6) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re "\u{5c}") (str.to_re "-"))) (str.to_re "\u{0a}"))))
; linkautomatici\x2EcomAID\x2FYourUser-Agent\x3AtoBasicwww\x2Ewebcruiser\x2Ecc
(assert (str.in_re X (str.to_re "linkautomatici.comAID/YourUser-Agent:toBasicwww.webcruiser.cc\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
