(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}flac/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".flac/i\u{0a}")))))
; ^([A-Z]{2}[9]{3}|[A-Z]{3}[9]{2}|[A-Z]{4}[9]{1}|[A-Z]{5})[0-9]{6}([A-Z]{1}[9]{1}|[A-Z]{2})[A-Z0,9]{3}$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 3 3) (str.to_re "9"))) (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) ((_ re.loop 2 2) (str.to_re "9"))) (re.++ ((_ re.loop 4 4) (re.range "A" "Z")) ((_ re.loop 1 1) (str.to_re "9"))) ((_ re.loop 5 5) (re.range "A" "Z"))) ((_ re.loop 6 6) (re.range "0" "9")) (re.union (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 1 1) (str.to_re "9"))) ((_ re.loop 2 2) (re.range "A" "Z"))) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (str.to_re "0") (str.to_re ",") (str.to_re "9"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}jp2/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jp2/i\u{0a}"))))
; /filename=[^\n]*\u{2e}xwd/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xwd/i\u{0a}")))))
(check-sat)
