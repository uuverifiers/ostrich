(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/se\/[a-f0-9]{100,200}\/[a-f0-9]{6,9}\/[A-Z0-9_]{4,200}\.com/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//se/") ((_ re.loop 100 200) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 6 9) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 4 200) (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) (str.to_re ".com/Ui\u{0a}")))))
; www\u{2e}proventactics\u{2e}comKeyloggerExplorerfileserverSI\|Server\|www\x2Emyarmory\x2Ecom
(assert (str.in_re X (str.to_re "www.proventactics.comKeyloggerExplorerfileserverSI|Server|\u{13}www.myarmory.com\u{0a}")))
; ICON="[^"]+"
(assert (not (str.in_re X (re.++ (str.to_re "ICON=\u{22}") (re.+ (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{22}\u{0a}")))))
; /\u{2e}m4p([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.m4p") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; OVN\s+\x2APORT3\x2A\[DRIVEwww\.raxsearch\.com
(assert (str.in_re X (re.++ (str.to_re "OVN") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "*PORT3*[DRIVEwww.raxsearch.com\u{0a}"))))
(check-sat)
