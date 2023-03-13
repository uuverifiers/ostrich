(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /"(\\["\\]|[^"])*("|$)|(\\["\\]|[^\s"])+/g
(assert (not (str.in_re X (re.union (re.++ (str.to_re "/\u{22}") (re.* (re.union (re.++ (str.to_re "\u{5c}") (re.union (str.to_re "\u{22}") (str.to_re "\u{5c}"))) (re.comp (str.to_re "\u{22}")))) (str.to_re "\u{22}")) (re.++ (re.+ (re.union (re.++ (str.to_re "\u{5c}") (re.union (str.to_re "\u{22}") (str.to_re "\u{5c}"))) (str.to_re "\u{22}") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/g\u{0a}"))))))
; /[a-zA-Z0-9]\/[a-f0-9]{5}\.swf[\u{22}\u{27}]/
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (str.to_re "/") ((_ re.loop 5 5) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".swf") (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "/\u{0a}"))))
; /filename=[^\n]*\u{2e}m4a/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".m4a/i\u{0a}")))))
(check-sat)
