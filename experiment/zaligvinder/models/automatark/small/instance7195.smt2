(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\+86)(13[0-9]|145|147|15[0-3,5-9]|18[0,2,5-9])(\d{8})$
(assert (not (str.in_re X (re.++ (str.to_re "+86") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}1") (re.union (re.++ (str.to_re "3") (re.range "0" "9")) (str.to_re "45") (str.to_re "47") (re.++ (str.to_re "5") (re.union (re.range "0" "3") (str.to_re ",") (re.range "5" "9"))) (re.++ (str.to_re "8") (re.union (str.to_re "0") (str.to_re ",") (str.to_re "2") (re.range "5" "9"))))))))
; /\u{3d}\u{3d}$/P
(assert (not (str.in_re X (str.to_re "/==/P\u{0a}"))))
; ToolbarUser-Agent\x3AFrom\x3A
(assert (str.in_re X (str.to_re "ToolbarUser-Agent:From:\u{0a}")))
; Host\x3A\ssource%3Dultrasearch136%26campaign%3Dsnap
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "source%3Dultrasearch136%26campaign%3Dsnap\u{0a}"))))
; ^[0-9]{2}
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
