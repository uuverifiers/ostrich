(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Serverulmxct\u{2f}mqoycWinSession\x2Fclient\x2F\x2APORT1\x2A
(assert (str.in_re X (str.to_re "Serverulmxct/mqoycWinSession/client/*PORT1*\u{0a}")))
; ^[0-9]{10}$|^\(0[1-9]{1}\)[0-9]{8}$|^[0-9]{8}$|^[0-9]{4}[ ][0-9]{3}[ ][0-9]{3}$|^\(0[1-9]{1}\)[ ][0-9]{4}[ ][0-9]{4}$|^[0-9]{4}[ ][0-9]{4}$
(assert (not (str.in_re X (re.union ((_ re.loop 10 10) (re.range "0" "9")) (re.++ (str.to_re "(0") ((_ re.loop 1 1) (re.range "1" "9")) (str.to_re ")") ((_ re.loop 8 8) (re.range "0" "9"))) ((_ re.loop 8 8) (re.range "0" "9")) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "(0") ((_ re.loop 1 1) (re.range "1" "9")) (str.to_re ") ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; /version\x3D[\u{22}\u{27}][^\u{22}\u{27}]{1024}/
(assert (str.in_re X (re.++ (str.to_re "/version=") (re.union (str.to_re "\u{22}") (str.to_re "'")) ((_ re.loop 1024 1024) (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "/\u{0a}"))))
(check-sat)
