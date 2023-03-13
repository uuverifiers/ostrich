(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; frame_ver2\s+communityLibrarySoftwareWinCrashcomHost\x3Atid\x3D\u{25}toolbar\x5Fid
(assert (str.in_re X (re.++ (str.to_re "frame_ver2") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "communityLibrarySoftwareWinCrashcomHost:tid=%toolbar_id\u{0a}"))))
; /[1-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}/H
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "1" "9") (re.range "A" "F"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/H\u{0a}"))))
; ^[0-9]+(,[0-9]+)*$
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.* (re.++ (str.to_re ",") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; protocolhttp\x3A\x2F\x2Fwww\.searchinweb\.com\x2Fsearch\.php\?said=bar
(assert (not (str.in_re X (str.to_re "protocolhttp://www.searchinweb.com/search.php?said=bar\u{0a}"))))
; encoder\s+cyber@yahoo\x2Ecomcu
(assert (not (str.in_re X (re.++ (str.to_re "encoder") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "cyber@yahoo.comcu\u{0a}")))))
(check-sat)
