(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}dcr/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".dcr/i\u{0a}")))))
; \b[1-9]\d{3}\ +[A-Z]{2}\b
(assert (not (str.in_re X (re.++ (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9")) (re.+ (str.to_re " ")) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}")))))
; ^~/[0-9a-zA-Z_][0-9a-zA-Z/_-]*\.[0-9a-zA-Z_-]+$
(assert (str.in_re X (re.++ (str.to_re "~/") (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_")) (re.* (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "/") (str.to_re "_") (str.to_re "-"))) (str.to_re ".") (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_") (str.to_re "-"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
