(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}sami/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".sami/i\u{0a}"))))
; (^\(\)$|^\(((\([0-9]+,(\((\([0-9]+,[0-9]+,[0-9]+\),)*(\([0-9]+,[0-9]+,[0-9]+\)){1}\))+\),)*(\([0-9]+,(\((\([0-9]+,[0-9]+,[0-9]+\),)*(\([0-9]+,[0-9]+,[0-9]+\)){1}\))+\)){1}\)))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}(") (re.union (str.to_re ")") (re.++ (re.* (re.++ (str.to_re "(") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.++ (str.to_re "(") (re.* (re.++ (str.to_re "(") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.range "0" "9")) (str.to_re "),"))) ((_ re.loop 1 1) (re.++ (str.to_re "(") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.range "0" "9")) (str.to_re ")"))) (str.to_re ")"))) (str.to_re "),"))) ((_ re.loop 1 1) (re.++ (str.to_re "(") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.++ (str.to_re "(") (re.* (re.++ (str.to_re "(") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.range "0" "9")) (str.to_re "),"))) ((_ re.loop 1 1) (re.++ (str.to_re "(") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.range "0" "9")) (str.to_re ")"))) (str.to_re ")"))) (str.to_re ")"))) (str.to_re ")"))))))
; ^[a-zA-Z]+(\.[a-zA-Z]+)+$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.+ (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
