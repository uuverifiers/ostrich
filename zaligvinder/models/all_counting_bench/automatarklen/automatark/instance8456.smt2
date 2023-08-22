(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[a-z]{4}\.html\?j\=\d{6,7}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 4 4) (re.range "a" "z")) (str.to_re ".html?j=") ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "/Ui\u{0a}"))))
; /\u{2e}rm([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.rm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; spas\s+This\s+\x7D\x7BPassword\x3A\s+OSSProxy\x5Chome\/lordofsearch
(assert (not (str.in_re X (re.++ (str.to_re "spas") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "This") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "}{Password:\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "OSSProxy\u{5c}home/lordofsearch\u{0a}")))))
; OVN\s+\x2APORT3\x2A\[DRIVEwww\.raxsearch\.com
(assert (str.in_re X (re.++ (str.to_re "OVN") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "*PORT3*[DRIVEwww.raxsearch.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
