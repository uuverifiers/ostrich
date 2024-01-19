(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}jpf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jpf/i\u{0a}")))))
; clvompycem\u{2f}cen\.vcnHost\x3AUser-Agent\x3A\u{0d}\u{0a}
(assert (not (str.in_re X (str.to_re "clvompycem/cen.vcnHost:User-Agent:\u{0d}\u{0a}\u{0a}"))))
; ^[1-9]{1}[0-9]{3}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
