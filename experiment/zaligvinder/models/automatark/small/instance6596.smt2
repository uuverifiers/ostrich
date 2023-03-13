(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; YWRtaW46cGFzc3dvcmQ\s+www\x2Ealfacleaner\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "YWRtaW46cGFzc3dvcmQ") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.alfacleaner.com\u{0a}")))))
; (^[0][2][1579]{1})(\d{6,7}$)
(assert (not (str.in_re X (re.++ ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "\u{0a}02") ((_ re.loop 1 1) (re.union (str.to_re "1") (str.to_re "5") (str.to_re "7") (str.to_re "9")))))))
; /^("(\\["\\]|[^"])*"|[^\n])*$/gm
(assert (str.in_re X (re.++ (str.to_re "/") (re.* (re.union (re.++ (str.to_re "\u{22}") (re.* (re.union (re.++ (str.to_re "\u{5c}") (re.union (str.to_re "\u{22}") (str.to_re "\u{5c}"))) (re.comp (str.to_re "\u{22}")))) (str.to_re "\u{22}")) (re.comp (str.to_re "\u{0a}")))) (str.to_re "/gm\u{0a}"))))
; /\&h=\d{5}$/iU
(assert (str.in_re X (re.++ (str.to_re "/&h=") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "/iU\u{0a}"))))
(check-sat)
