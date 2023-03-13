(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^
(assert (not (str.in_re X (str.to_re "\u{0a}"))))
; ^[2-7]{1}[0-9]{3}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "2" "7")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; hotbar\s+ocllceclbhs\u{2f}gthftpquickbruteUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "hotbar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ocllceclbhs/gthftpquickbruteUser-Agent:\u{0a}"))))
(check-sat)
