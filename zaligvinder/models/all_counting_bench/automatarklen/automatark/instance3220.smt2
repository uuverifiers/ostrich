(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}jpe([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.jpe") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; subject\x3A.*Login\s+adfsgecoiwnf
(assert (str.in_re X (re.++ (str.to_re "subject:") (re.* re.allchar) (str.to_re "Login") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "adfsgecoiwnf\u{1b}\u{0a}"))))
; hirmvtg\u{2f}ggqh\.kqh\d+sports\w+whenu\x2Ecomwp-includes\x2Ffeed\x2Ephp\x3F
(assert (str.in_re X (re.++ (str.to_re "hirmvtg/ggqh.kqh\u{1b}") (re.+ (re.range "0" "9")) (str.to_re "sports") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "whenu.com\u{13}wp-includes/feed.php?\u{0a}"))))
; /filename=[^\n]*\u{2e}mks/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mks/i\u{0a}"))))
; ^([34|37]{2})([0-9]{13})$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (str.to_re "3") (str.to_re "4") (str.to_re "|") (str.to_re "7"))) ((_ re.loop 13 13) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
