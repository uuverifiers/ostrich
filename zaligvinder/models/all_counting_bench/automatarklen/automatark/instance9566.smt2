(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Eyok\x2Ecom\s+jupitersatellites\x2Ebiz.*User-Agent\x3Aclvompycem\u{2f}cen\.vcn
(assert (str.in_re X (re.++ (str.to_re "www.yok.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "jupitersatellites.biz") (re.* re.allchar) (str.to_re "User-Agent:clvompycem/cen.vcn\u{0a}"))))
; /\u{2e}j2k([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.j2k") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; (\s*\S*){2}(ipsum)(\S*\s*){2}
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))) (str.to_re "ipsum") ((_ re.loop 2 2) (re.++ (re.* (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (str.to_re "\u{0a}"))))
; (^0[78][2347][0-9]{7})
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}0") (re.union (str.to_re "7") (str.to_re "8")) (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "7")) ((_ re.loop 7 7) (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
