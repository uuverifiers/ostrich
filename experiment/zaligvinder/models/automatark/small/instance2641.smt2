(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^\d{1,3}$)|(\d{1,3})\.?(\d{0,0}[0,5])
(assert (str.in_re X (re.union ((_ re.loop 1 3) (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (str.to_re ".")) (str.to_re "\u{0a}") ((_ re.loop 0 0) (re.range "0" "9")) (re.union (str.to_re "0") (str.to_re ",") (str.to_re "5"))))))
; /filename=[^\n]*\u{2e}flac/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".flac/i\u{0a}")))))
; /\u{2e}rmp([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.rmp") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(check-sat)
