(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}maplet/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".maplet/i\u{0a}"))))
; (^\d*\.\d{2}$)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.* (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))))))
; X-Spam-Level:\s[*]{11}
(assert (str.in_re X (re.++ (str.to_re "X-Spam-Level:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 11 11) (str.to_re "*")) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}smi/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".smi/i\u{0a}")))))
(check-sat)
