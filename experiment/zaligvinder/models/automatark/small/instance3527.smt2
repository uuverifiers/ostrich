(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3Atwfofrfzlugq\u{2f}eve\.qduuid=ppcdomain\x2Eco\x2EukGuardedReferer\x3AreadyLOGUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "User-Agent:twfofrfzlugq/eve.qduuid=ppcdomain.co.ukGuardedReferer:readyLOGUser-Agent:\u{0a}"))))
; GmbH\x2FcommunicatortbHost\x3AUser-Agent\x3Aadblock\x2Elinkz\x2Ecom
(assert (str.in_re X (str.to_re "GmbH/communicatortbHost:User-Agent:adblock.linkz.com\u{0a}")))
; ^([0-9a-fA-F]){8}$
(assert (not (str.in_re X (re.++ ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "\u{0a}")))))
; u=with\x3AHBand,Deathhoroscope2
(assert (str.in_re X (str.to_re "u=with:HBand,Deathhoroscope2\u{0a}")))
(check-sat)
