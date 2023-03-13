(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\([0-9]{3}\)[0-9]{3}(-)[0-9]{4}
(assert (str.in_re X (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; frame_ver2\s+communityLibrarySoftwareWinCrashcomHost\x3Atid\x3D\u{25}toolbar\x5Fid
(assert (str.in_re X (re.++ (str.to_re "frame_ver2") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "communityLibrarySoftwareWinCrashcomHost:tid=%toolbar_id\u{0a}"))))
; User-Agent\x3Atwfofrfzlugq\u{2f}eve\.qduuid=ppcdomain\x2Eco\x2EukGuardedReferer\x3AreadyLOGUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "User-Agent:twfofrfzlugq/eve.qduuid=ppcdomain.co.ukGuardedReferer:readyLOGUser-Agent:\u{0a}"))))
(check-sat)
