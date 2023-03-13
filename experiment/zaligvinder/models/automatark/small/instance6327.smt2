(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}apk/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".apk/i\u{0a}"))))
; /^(\d{1,2})(\/)(\d{1,2})(\/)(\d{4})(T|\s{1,2})(([0-1][0-9])|(2[0-3])):([0-5][0-9])+$/;
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (re.union (str.to_re "T") ((_ re.loop 1 2) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.+ (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re "/;\u{0a}")))))
; /filename=[^\n]*\u{2e}quo/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".quo/i\u{0a}")))))
; /\u{2e}rp([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.rp") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(check-sat)
