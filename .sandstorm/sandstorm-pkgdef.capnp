@0xdd64070b2a0a30f9;

using Spk = import "/sandstorm/package.capnp";
using Util = import "/sandstorm/util.capnp";

const pkgdef :Spk.PackageDefinition = (
  id = "g1k27td96hm9fjnkn20jw5apkphhcd5wrcccdve9fuvykfz68650",
  # Your app ID is actually its public key. The private key was placed in
  # your keyring. All updates must be signed with the same key.

  manifest = (
    appTitle = (defaultText = "GitWeb+Pages by abliss"),
    appVersion = 11,  # Increment this for every release.
    appMarketingVersion = (defaultText = "0.1.1"),
    metadata = (
      icons = (
        appGrid = (svg = embed "app-graphics/gitweb-128.svg"),
        grain = (svg = embed "app-graphics/gitweb-24.svg"),
        market = (svg = embed "app-graphics/gitweb-150.svg"),
      ),
      website = "http://git-scm.com/docs/gitweb",
      codeUrl = "https://github.com/abliss/gitwebpages-sandstorm",
      license = (openSource = gpl2),
      categories = [developerTools,],
      author = (
        upstreamAuthor = "Christian Gierke and Kay Sievers",
        contactEmail = "abliss@gmail.com",
        pgpSignature = embed "pgp-signature",
      ),
      pgpKeyring = embed "keyring",
      description = (defaultText = embed "description.md"),
      shortDescription = (defaultText = "Git hosting"),
      screenshots = [(width = 448, height = 288, png = embed "screenshot.png")],
      changeLog = (defaultText = embed "changeLog.md"),
    ),

    actions = [
      ( title = (defaultText = "New GitWeb Repository"),
        command = .startCommand
      )
    ],

    continueCommand = .continueCommand
  ),

  sourceMap = (
    searchPath = [
      ( sourcePath = "." ),  # Search this directory first.
      ( sourcePath = "/",    # Then search the system root directory.
        hidePaths = [ "home", "proc", "sys",
                      "etc/nsswitch.conf", "etc/passwd", "etc/shadow", "etc/ssl/openssl.cnf"]
      )
    ]
  ),

  fileList = "sandstorm-files.list",

  alwaysInclude = [],

  bridgeConfig = (
    viewInfo = (
      permissions = [(name = "read", title = (defaultText = "read"),
                      description = (defaultText = "allows `git fetch`")),
                     (name = "write", title = (defaultText = "write"),
                      description = (defaultText = "allows `git push`"))],
      roles = [(title = (defaultText = "guest"),
                permissions = [true, false],
                verbPhrase = (defaultText = "can read")),
               (title = (defaultText = "developer"),
                permissions = [true, true],
                verbPhrase = (defaultText = "can read and write"),
                default = true)]
    ),
    apiPath = "/repo.git/"
  )
);

const commandEnvironment : List(Util.KeyValue) =
  [
    (key = "PATH", value = "/usr/local/bin:/usr/bin:/bin")
  ];

const startCommand :Spk.Manifest.Command = (
  argv = ["/sandstorm-http-bridge", "10000", "--", "/bin/sh", "start.sh"],
  environ = .commandEnvironment
);


const continueCommand :Spk.Manifest.Command = (
  argv = ["/sandstorm-http-bridge", "10000", "--", "/bin/sh", "continue.sh"],
  environ = .commandEnvironment
);
