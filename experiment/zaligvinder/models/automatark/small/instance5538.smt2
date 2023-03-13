(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \[(.+)\].+\[n?varchar\].+NULL,
(assert (not (str.in_re X (re.++ (str.to_re "[") (re.+ re.allchar) (str.to_re "]") (re.+ re.allchar) (str.to_re "[") (re.opt (str.to_re "n")) (str.to_re "varchar]") (re.+ re.allchar) (str.to_re "NULL,\u{0a}")))))
; /^USER\u{20}(XP|98|95|NT|ME|WIN|2K3)\u{2d}\d+\u{20}\u{2a}\u{20}\u{30}\u{20}\u{3a}/mi
(assert (str.in_re X (re.++ (str.to_re "/USER ") (re.union (str.to_re "XP") (str.to_re "98") (str.to_re "95") (str.to_re "NT") (str.to_re "ME") (str.to_re "WIN") (str.to_re "2K3")) (str.to_re "-") (re.+ (re.range "0" "9")) (str.to_re " * 0 :/mi\u{0a}"))))
; /\/jdb\/inf\.php\?id=[a-f0-9]{32}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//jdb/inf.php?id=") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}"))))
; /filename=[^\n]*\u{2e}ram/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ram/i\u{0a}"))))
; www\x2Ewebcruiser\x2Eccgot
(assert (str.in_re X (str.to_re "www.webcruiser.ccgot\u{0a}")))
(check-sat)
