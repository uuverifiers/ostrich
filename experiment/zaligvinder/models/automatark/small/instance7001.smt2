(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; DA\dwww\x2Ee-finder\x2Ecc.*User-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "DA") (re.range "0" "9") (str.to_re "www.e-finder.cc") (re.* re.allchar) (str.to_re "User-Agent:\u{0a}"))))
; /filename=[^\n]*\u{2e}vap/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".vap/i\u{0a}"))))
; /^[a-z][\w\.]+@([\w\-]+\.)+[a-z]{2,7}$/i
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.range "a" "z") (re.+ (re.union (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.++ (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "."))) ((_ re.loop 2 7) (re.range "a" "z")) (str.to_re "/i\u{0a}")))))
; ^#(\d{6})|^#([A-F]{6})|^#([A-F]|[0-9]){6}
(assert (not (str.in_re X (re.++ (str.to_re "#") (re.union ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 6 6) (re.range "A" "F")) (re.++ ((_ re.loop 6 6) (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "\u{0a}")))))))
(check-sat)
