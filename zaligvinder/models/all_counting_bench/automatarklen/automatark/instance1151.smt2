(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /myversion\u{7c}(\d\u{2e}){3}\d\u{0d}\u{0a}/
(assert (not (str.in_re X (re.++ (str.to_re "/myversion|") ((_ re.loop 3 3) (re.++ (re.range "0" "9") (str.to_re "."))) (re.range "0" "9") (str.to_re "\u{0d}\u{0a}/\u{0a}")))))
; com\x2Findex\.php\?tpid=\x7D\x7BUser\x3A
(assert (str.in_re X (str.to_re "com/index.php?tpid=}{User:\u{0a}")))
; clvompycem\u{2f}cen\.vcnHost\x3AUser-Agent\x3A\u{0d}\u{0a}
(assert (not (str.in_re X (str.to_re "clvompycem/cen.vcnHost:User-Agent:\u{0d}\u{0a}\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
