(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^("(\\["\\]|[^"])*"|[^\n])*(\n|$)/gm
(assert (str.in_re X (re.++ (str.to_re "/") (re.* (re.union (re.++ (str.to_re "\u{22}") (re.* (re.union (re.++ (str.to_re "\u{5c}") (re.union (str.to_re "\u{22}") (str.to_re "\u{5c}"))) (re.comp (str.to_re "\u{22}")))) (str.to_re "\u{22}")) (re.comp (str.to_re "\u{0a}")))) (str.to_re "\u{0a}/gm\u{0a}"))))
; /filename=[^\n]*\u{2e}smi/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".smi/i\u{0a}"))))
; Referer\x3Amywaynowpgwtjgxwthx\u{2f}byb\.xkywww\x2Eu88\x2Ecnsource%3Dultrasearch136%26campaign%3Dsnap
(assert (not (str.in_re X (str.to_re "Referer:mywaynowpgwtjgxwthx/byb.xkywww.u88.cnsource%3Dultrasearch136%26campaign%3Dsnap\u{0a}"))))
; /filename=[^\n]*\u{2e}url/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".url/i\u{0a}"))))
; (^[0-9]{0,10}$)
(assert (str.in_re X (re.++ ((_ re.loop 0 10) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
