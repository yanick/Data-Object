requires "Clone" => "0.37";
requires "Moo" => "1.006001";
requires "Type::Tiny" => "1.000005";
requires "perl" => "v5.10.0";

on 'test' => sub {
  requires "perl" => "v5.10.0";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};
