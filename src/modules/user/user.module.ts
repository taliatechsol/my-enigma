import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { UserController } from 'src/controllers/user/user.controller';
import { userSchema } from 'src/schemas/user.schema';
import { UserService } from 'src/services/user/user.service';

@Module({
  imports: [MongooseModule.forFeature([{ name: 'users', schema: userSchema }])],
  controllers: [UserController],
  providers: [UserService],
})
export class UserModule {}
