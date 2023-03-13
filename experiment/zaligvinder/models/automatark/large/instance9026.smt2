(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}url/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".url/i\u{0a}")))))
; ^([a-zA-Z.\s']{1,50})$
(assert (str.in_re X (re.++ ((_ re.loop 1 50) (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re ".") (str.to_re "'") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; /^\/[a-f0-9]{8}\.js\?cp\u{3d}/Umi
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".js?cp=/Umi\u{0a}")))))
; [1-9][0-9]
(assert (not (str.in_re X (re.++ (re.range "1" "9") (re.range "0" "9") (str.to_re "\u{0a}")))))
; /\u{23}\d{2}\u{3a}\d{2}\u{3a}\d\d$/R
(assert (str.in_re X (re.++ (str.to_re "/#") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ":") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ":") (re.range "0" "9") (re.range "0" "9") (str.to_re "/R\u{0a}"))))
(check-sat)
