(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ([a-zA-Z0-9\_\-\.]+[a-zA-Z0-9\_\-\.]+[a-zA-Z0-9\_\-\.]+)+@([a-zA-z0-9][a-zA-z0-9][a-zA-z0-9]*)+(\.[a-zA-z0-9][a-zA-z0-9][a-zA-z0-9]*)(\.[a-zA-z0-9]+)*
(assert (not (str.in_re X (re.++ (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))))) (str.to_re "@") (re.+ (re.++ (re.union (re.range "a" "z") (re.range "A" "z") (re.range "0" "9")) (re.union (re.range "a" "z") (re.range "A" "z") (re.range "0" "9")) (re.* (re.union (re.range "a" "z") (re.range "A" "z") (re.range "0" "9"))))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "z") (re.range "0" "9"))))) (str.to_re "\u{0a}.") (re.union (re.range "a" "z") (re.range "A" "z") (re.range "0" "9")) (re.union (re.range "a" "z") (re.range "A" "z") (re.range "0" "9")) (re.* (re.union (re.range "a" "z") (re.range "A" "z") (re.range "0" "9")))))))
; \d{3}[.-]?\d{3}[.-]?\d{4}
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re ".") (str.to_re "-"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re ".") (str.to_re "-"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Fictional[^\n\r]*v\x3B[^\n\r]*\u{22}Stealth\d+moreKontikiHost\u{3a}AcmeEvilFTPHost\x3ATOOLBARSupremePort\x2E
(assert (str.in_re X (re.++ (str.to_re "Fictional") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "v;") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}Stealth") (re.+ (re.range "0" "9")) (str.to_re "moreKontikiHost:AcmeEvilFTPHost:TOOLBARSupremePort.\u{0a}"))))
; [D]?[-D]?[0-9]{5}
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "D")) (re.opt (re.union (str.to_re "-") (str.to_re "D"))) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
