(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}lnk([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.lnk") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^(([a-h,A-H,j-n,J-N,p-z,P-Z,0-9]{9})([a-h,A-H,j-n,J-N,p,P,r-t,R-T,v-z,V-Z,0-9])([a-h,A-H,j-n,J-N,p-z,P-Z,0-9])(\d{6}))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 9 9) (re.union (re.range "a" "h") (str.to_re ",") (re.range "A" "H") (re.range "j" "n") (re.range "J" "N") (re.range "p" "z") (re.range "P" "Z") (re.range "0" "9"))) (re.union (re.range "a" "h") (str.to_re ",") (re.range "A" "H") (re.range "j" "n") (re.range "J" "N") (str.to_re "p") (str.to_re "P") (re.range "r" "t") (re.range "R" "T") (re.range "v" "z") (re.range "V" "Z") (re.range "0" "9")) (re.union (re.range "a" "h") (str.to_re ",") (re.range "A" "H") (re.range "j" "n") (re.range "J" "N") (re.range "p" "z") (re.range "P" "Z") (re.range "0" "9")) ((_ re.loop 6 6) (re.range "0" "9")))))
; /filename=[^\n]*\u{2e}tga/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".tga/i\u{0a}")))))
; SpywareStrike.*Subject\x3A\s+Pcast\x2Edat\x2EToolbar
(assert (not (str.in_re X (re.++ (str.to_re "SpywareStrike") (re.* re.allchar) (str.to_re "Subject:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Pcast.dat.Toolbar\u{0a}")))))
; from\x3AHost\u{3a}www\.thecommunicator\.net
(assert (str.in_re X (str.to_re "from:Host:www.thecommunicator.net\u{0a}")))
(check-sat)
