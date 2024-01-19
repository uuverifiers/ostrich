(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ICON="[^"]+"
(assert (not (str.in_re X (re.++ (str.to_re "ICON=\u{22}") (re.+ (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{22}\u{0a}")))))
; (?i)\w.*\@\w*\.\w*
(assert (str.in_re X (re.++ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.* re.allchar) (str.to_re "@") (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
; (\d{3}\-\d{2}\-\d{4})
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
