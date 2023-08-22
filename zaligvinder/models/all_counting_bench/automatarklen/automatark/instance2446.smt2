(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; .*-[0-9]{1,10}.*
(assert (not (str.in_re X (re.++ (re.* re.allchar) (str.to_re "-") ((_ re.loop 1 10) (re.range "0" "9")) (re.* re.allchar) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}hhk/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".hhk/i\u{0a}"))))
; ^([0-9]|[1-9]\d|[1-7]\d{2}|800)$
(assert (not (str.in_re X (re.++ (re.union (re.range "0" "9") (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "7") ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "800")) (str.to_re "\u{0a}")))))
; /^\/\?[a-f0-9]{32}$/U
(assert (str.in_re X (re.++ (str.to_re "//?") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
