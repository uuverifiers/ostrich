(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A.*www\u{2e}2-seek\u{2e}com\u{2f}search
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "www.2-seek.com/search\u{0a}"))))
; ^(([1-9]{1})|([0-1][1-2])|(0[1-9])|([1][0-2])):([0-5][0-9])(([aA])|([pP]))[mM]$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (re.range "1" "9")) (re.++ (re.range "0" "1") (re.range "1" "2")) (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re ":") (re.union (str.to_re "a") (str.to_re "A") (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "m") (str.to_re "M")) (str.to_re "\u{0a}") (re.range "0" "5") (re.range "0" "9")))))
; snprtz\x7Cdialnoref\x3D\u{25}user\x5FidPG=SPEEDBAR
(assert (not (str.in_re X (str.to_re "snprtz|dialnoref=%user_idPG=SPEEDBAR\u{0a}"))))
(check-sat)
