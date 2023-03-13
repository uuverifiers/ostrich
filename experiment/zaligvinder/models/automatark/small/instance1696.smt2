(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d*((\.\d+)?)*$
(assert (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.* (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
; ^([987]{1})(\d{1})(\d{8})
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "9") (str.to_re "8") (str.to_re "7"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Host\x3A\sclvompycem\u{2f}cen\.vcn
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "clvompycem/cen.vcn\u{0a}"))))
; /filename=[^\n]*\u{2e}mka/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mka/i\u{0a}"))))
; /filename=[^\n]*\u{2e}fon/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".fon/i\u{0a}"))))
(check-sat)
